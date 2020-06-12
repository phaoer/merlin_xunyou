#!/bin/bash

server=$2
gateway=${3}
port=${4}
device=${5}
rtName="95"
iptName="XUNYOU"
iptAccName="XUNYOUACC"

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

function acc_rule_config()
{
    #配置mangle表
    local ret=`iptables -t mangle -S | grep ${iptAccName}`
    [ -z "${ret}" ] && iptables -t mangle -N ${iptAccName}
    iptables -t mangle -F ${iptAccName}
    iptables -t mangle -A ${iptAccName} -d ${gateway} -j ACCEPT
    
    #配置nat表
    ret=`iptables -t nat -S | grep ${iptAccName}`
    [ -z "${ret}" ] && iptables -t nat -N ${iptAccName}
    iptables -t nat -F ${iptAccName}
    iptables -t nat -A ${iptAccName} -d ${gateway} -j ACCEPT

    #
    if [[ -n "${device1}" && "${device1}" != "0.0.0.0" ]]; then
        #
        markNum=`echo ${device1} | awk -F '.' '{printf "0x%02x%02x%02x%02x",$1,$2,$3,$4}'`
        #
        ret=`ip rule | grep "${device1}"`
        [ -z "${ret}" ] && ip rule add from ${device1} fwmark ${markNum} pref 98 t ${rtName}
        #
        iptables -t nat -A ${iptAccName} -s ${device1} -p tcp -j DNAT --to-destination ${gateway}:${port}
        #iptables -t mangle -A ${iptAccName} -s ${device1} -p tcp -j MARK --set-mark ${markNum}
        iptables -t mangle -A ${iptAccName} -s ${device1} -p udp -j TPROXY --tproxy-mark ${markNum} --on-ip 127.0.0.1 --on-port ${port}
    fi

    if [[ -n "${device2}" && "${device2}" != "0.0.0.0" ]]; then
        #
        markNum=`echo ${device2} | awk -F '.' '{printf "0x%02x%02x%02x%02x",$1,$2,$3,$4}'`
        #
        ret=`ip rule | grep "${device2}"`
        [ -z "${ret}" ] && ip rule add from ${device2} fwmark ${markNum} pref 99 t ${rtName}
        #
        iptables -t nat -A ${iptAccName} -s ${device2} -p tcp -j DNAT --to-destination ${gateway}:${port}
        #iptables -t mangle -A ${iptAccName} -s ${device2} -p tcp -j MARK --set-mark ${markNum}
        iptables -t mangle -A ${iptAccName} -s ${device2} -p udp -j TPROXY --tproxy-mark ${markNum} --on-ip 127.0.0.1 --on-port ${port}
    fi

    ret=`ip rule | grep "lookup ${rtName}"`
    [ -n "${ret}" ] && ip r f t ${rtName} && ip r a local default dev lo t ${rtName}
}

function del_iptables_rule()
{
    #
    ret=`iptables -t mangle -S | grep ${iptAccName}`
    [ -n "${ret}" ] && iptables -t mangle -F ${iptAccName}
    #
    ret=`iptables -t nat -S | grep ${iptAccName}`
    [ -n "${ret}" ] && iptables -t nat -F ${iptAccName}
}

function del_ip_rule()
{
    #
    ret=`ip rule | grep "lookup ${rtName}"`
    [ -n "${ret}" ] && ip r f t ${rtName}
    #
    if [[ -n "${device1}" && "${device1}" != "0.0.0.0" ]]; then
        ret=`ip rule | grep "${device1}"`
        [ -n "${ret}" ] && ip rule del t ${rtName}
    fi
    #
    if [[ -n "${device2}" && "${device2}" != "0.0.0.0" ]]; then
        ret=`ip rule | grep "${device2}"`
        [ -n "${ret}" ] && ip rule del t ${rtName}
    fi
    #
    ret=`ip rule | grep ${rtName}`
    [ -n "${ret}" ] && ip rule d t ${rtName}
}

function clear_rule_config()
{
    #
    del_ip_rule
    #
    del_iptables_rule
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
