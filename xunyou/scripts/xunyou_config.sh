#!/bin/bash

source /koolshare/scripts/base.sh
eval `dbus export xunyou`

module="xunyou_acc"
ifname="br0"
BasePath="/koolshare/xunyou"
domain="lan.xunyou.com"
RouteCfg="${BasePath}/config/RouteCfg.conf"
ProxyCfg="${BasePath}/config/ProxyCfg.conf"
ProxyCfgPort="29595"
RouteLog="/var/log/ctrl.log"
ProxyLog="/var/log/proxy.log"
ProxyScripte="${BasePath}/scripts/xunyou_rule.sh"
UpdateScripte="${BasePath}/scripts/xunyou_update.sh"
CfgScripte="${BasePath}/scripts/xunyou_config.sh"
LibPath="${BasePath}/lib/"
RCtrProc="xy-ctrl"
ProxyProc="xy-proxy"


function write_hostname()
{
    flag=`cat /ect/hosts | grep ${domain}`
    [ -n "${flag}" ] && return 0

    chmod 777 /etc/hosts
    data=`ip address show ${ifname}`
    [ -z "${data}" ] && return 1

    gateway=`echo ${data} | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}'`
    [ -z "${gateway}" ] && return 1
    echo "${gateway} ${domain}" >> /etc/hosts
}

function create_config_file()
{
    data=`ip address show ${ifname}`
    [ -z "${data}" ] && return 1
    gateway=`echo ${data} | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}'`
    mac=`echo ${data} | grep link | awk -F ' ' '{print $2}'`
    [[ -z "${gateway}" || -z "${mac}" ]] && return 1
    RouteName=`uname -o`
    [ -z "${RouteName}" ] && RouteName="meilin"
    flag=`netstat -a | grep ${ProxyCfgPort}`
    [ -n "${flag}" ] && ProxyCfgPort="39595"
    #
    sed -i 's/\("httpd-svr":"\).*/\1'${gateway}'",/g' ${RouteCfg}
    sed -i 's/\("route-mac":"\).*/\1'${mac}'",/g'     ${RouteCfg}
    sed -i 's/\("log":"\).*/\1'${RouteLog}'",/g'      ${RouteCfg}
    sed -i 's/\("net-device":"\).*/\1'${ifname}'",/g'              ${RouteCfg}
    sed -i 's/\("route-name":"\).*/\1'${RouteName}'",/g'           ${RouteCfg}
    sed -i 's/\("proxy-manage-port":"\).*/\1'${ProxyCfgPort}'",/g' ${RouteCfg}
    sed -i 's/\("upgrade-shell":"\).*/\1'${UpdateScripte}'",/g'    ${RouteCfg}
    #
    sed -i 's/\("local-ip":"\).*/\1'${gateway}'",/g'        ${ProxyCfg}
    sed -i 's/\("manage":"\).*/\1'${ProxyCfgPort}'",/g'     ${ProxyCfg}
    sed -i 's/\("log":"\).*/\1'${ProxyLog}'",/g'            ${ProxyCfg}
    sed -i 's/\("script-cfg":"\).*/\1'${ProxyScripte}'",/g' ${ProxyCfg}
}

function  check_env_rely()
{
    export LD_LIBRARY_PATH=${LibPath}:$LD_LIBRARY_PATH
}

function xunyou_acc_start()
{
    #
    write_hostname
    #
    create_config_file
    #
    export LD_LIBRARY_PATH=${LibPath}:$LD_LIBRARY_PATH
    #
    ${BasePath}/bin/${RCtrProc} --config ${RouteCfg} &
    ${BasePath}/bin/${ProxyCfg} --config ${ProxyCfg} &
}

function xunyou_acc_install()
{
    #
    ret=`cru l | grep "${CfgScripte}"`
    [ -z "${ret}" ] && cru a ${module} "*/2 * * * * ${CfgScripte} check"
    #
    write_hostname
}

function xunyou_acc_uninstall()
{
    #
    cru d ${module}
    #
}

function xunyou_acc_stop()
{
    ctrlPid=`ps | grep -v grep | grep -w ${RCtrProc} | awk -F ' ' '{print $1}'`
    [ -n "${ctrlPid}" ] && kill -9 ${ctrlPid}
    proxyPid=`ps | grep -v grep | grep -w ${ProxyProc} | awk -F ' ' '{print $1}'`
    [ -n "${proxyPid}" ] && kill -9 ${proxyPid}
}

function xunyou_acc_check()
{
    [ "${xunyou_enable}" != "1" ] && return 0
    #
    ctrlPid=`ps | grep -v grep | grep -w ${RCtrProc} | awk -F ' ' '{print $1}'`
    proxyPid=`ps | grep -v grep | grep -w ${ProxyProc} | awk -F ' ' '{print $1}'`
    [[ -n "${ctrlPid}" && -n "${proxyPid}" ]] && return 0
    #
    xunyou_acc_stop
    xunyou_acc_start
}


case $1 in
    install)
        xunyou_acc_install
        ;;

    uninstall)
        xunyou_acc_uninstall
        ;;

    start)
        if [ "$xunyou_enable" == "1" ];then
            logger "[软件中心]: 启动迅游模块！"
            xunyou_acc_start
        else
            logger "[软件中心]: 未设置开机启动，跳过！"
        fi
        ;;

    stop)
        xunyou_acc_stop
        ;;

    check)
        xunyou_acc_check
        ;;

    *)
        if [ "$xunyou_enable" == "1" ];then
            xunyou_acc_install
            xunyou_acc_start
        else
            xunyou_acc_stop
        fi
        ;;

esac