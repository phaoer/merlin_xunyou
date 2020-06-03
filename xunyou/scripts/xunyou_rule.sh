#!/bin/bash

server=$2
gateway=${3}
port=${4}
device=${5}
rtName="95"
markNum="0x95"
iptName="XUNYOU"
ifname="br0"
#
node_ip=`echo ${server} | awk -F '=' '{print $2}'`
device1=`echo ${device} | awk -F '&' '{print $1}' | awk -F '=' '{print $2}'`
device2=`echo ${device} | awk -F '&' '{print $2}' | awk -F '=' '{print $2}'`
gateway=`echo ${gateway} | awk -F '=' '{print $2}'`
port=`echo ${port} | awk -F '=' '{print $2}'`

[[ -z "${device1}" && -z "${device2}" ]] && exit 1
[[ "${device1}" == "0.0.0.0" && "${device2}" == "0.0.0.0" ]] && exit 1

#
function check_depend_env()
{
    local ret=`lsmod | grep xt_TPROXY`
    [ -n "${ret}" ] && echo 0 && return 0
    #
	modprobe xt_TPROXY
}

function domain_rule_cfg()
{
    match="|03|lan|06|xunyou|03|com"
    #
    data=`iptables -t mangle -S XUNYOU | grep "036c616e0678756e796f7503636f6d"`
    [ -z "${data}" ] && iptables -t mangle -I ${iptName} -i ${ifname} -p udp --dport 53 -m string --hex-string "${match}" --algo kmp -j ACCEPT
}

function acc_rule_config()
{
    #配置mangle表
    local ret=`iptables -t mangle -S | grep ${iptName}`
    [ -z "${ret}" ] && iptables -t mangle -N ${iptName}
    iptables -t mangle -F ${iptName}
    domain_rule_cfg
    iptables -t mangle -A ${iptName} -d ${gateway} -j ACCEPT
    
    #配置nat表
    ret=`iptables -t nat -S | grep ${iptName}`
    [ -z "${ret}" ] && iptables -t nat -N ${iptName}
    iptables -t nat -F ${iptName}
    iptables -t nat -A ${iptName} -d ${gateway} -j ACCEPT

    #
    if [[ -n "${device1}" && "${device1}" != "0.0.0.0" ]]; then
        #
        ret=`ip rule | grep "${device1}"`
        [ -z "${ret}" ] && ip rule add from ${device1} fwmark ${markNum} pref 98 t ${rtName}
        #
        iptables -t nat -A ${iptName} -s ${device1} -p tcp -j DNAT --to-destination ${gateway}:${port}
        iptables -t mangle -A ${iptName} -s ${device1} -p udp -j TPROXY --tproxy-mark ${markNum} --on-ip 127.0.0.1 --on-port ${port}
    fi

    if [[ -n "${device2}" && "${device2}" != "0.0.0.0" ]]; then
        ret=`ip rule | grep "${device2}"`
        [ -z "${ret}" ] && ip rule add from ${device2} fwmark ${markNum} pref 99 t ${rtName}
        #
        iptables -t nat -A ${iptName} -s ${device2} -p tcp -j DNAT --to-destination ${gateway}:${port}
        iptables -t mangle -A ${iptName} -s ${device2} -p udp -j TPROXY --tproxy-mark ${markNum} --on-ip 127.0.0.1 --on-port ${port}
    fi

    ret=`ip rule | grep "lookup ${rtName}"`
    [ -n "${ret}" ] && ip r f t ${rtName} && ip r a local default dev lo t ${rtName}
    #
    iptables -t nat -I PREROUTING -i ${ifname} -p tcp -j ${iptName}
    iptables -t mangle -I PREROUTING -i ${ifname} -p udp -j ${iptName}
}

function clear_rule_config()
{
    #
    local ret=`iptables -t mangle -S | grep ${iptName}`
    [ -n "${ret}" ] && iptables -t mangle -F ${iptName}
    [ -n "${ret}" ] && iptables -t mangle -D PREROUTING -p udp -j ${iptName} >/dev/null 2>&1
    #
    ret=`iptables -t nat -S | grep ${iptName}`
    [ -n "${ret}" ] && iptables -t nat -F ${iptName}
    [ -n "${ret}" ] && iptables -t nat -D PREROUTING -p tcp -j ${iptName} >/dev/null 2>&1
    #
    ret=`ip rule | grep "lookup ${rtName}"`
    [ -n "${ret}" ] && ip r f t ${rtName}

    if [[ -n "${device1}" && "${device1}" != "0.0.0.0" ]]; then
        ret=`ip rule | grep "${device1}"`
        [ -n "${ret}" ] && ip rule del t ${rtName}
    fi

    if [[ -n "${device2}" && "${device2}" != "0.0.0.0" ]]; then
        ret=`ip rule | grep "${device2}"`
        [ -n "${ret}" ] && ip rule del t ${rtName}
    fi
}

function proc_client_online()
{
    #echo $node_ip, ${gateway}, ${port}, ${device1}, ${device2}
    #
    local ret=$(check_depend_env)
    ((${ret} != 0)) && return 1
    #
    clear_rule_config
    acc_rule_config
}

function proc_client_offline()
{
    #echo $node_ip, ${gateway}, ${port}, ${device1}, ${device2}
    #
    clear_rule_config
}

case $1 in
    "client-online")
        proc_client_online
        ;;

    "client-offline")
        proc_client_offline
        ;;
esac
