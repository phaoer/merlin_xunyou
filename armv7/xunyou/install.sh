#!/bin/sh

# for arm384 platform

MODULE=xunyou
title="迅游加速器"
VERSION="1.0.0.3"
systemType=0

remove_install_file(){
    rm -rf /tmp/${MODULE}*.gz > /dev/null 2>&1
    rm -rf /tmp/${MODULE} > /dev/null 2>&1
}

cd /tmp

case $(uname -m) in
    armv7l)
        ;;

    *)
        echo [`date +"%Y-%m-%d %H:%M:%S"`] "本插件适用于【koolshare merlin hnd/axhnd armv7l】固件平台，你的平台：$(uname -m)不能安装！！！"
        echo [`date +"%Y-%m-%d %H:%M:%S"`] "退出安装！"
        remove_install_file
        exit 1
        ;;
esac


if [ -d "/koolshare" ];then
    systemType=0
else
    systemType=1
    [ ! -d "/jffs" ] && systemType=2
fi

koolshare_install()
{
    enable=`dbus get ${MODULE}_enable`
    [ "${enable}" == "1" ] && sh /koolshare/xunyou/scripts/${MODULE}_config.sh stop
    #
    [ -d "/koolshare/xunyou" ] && rm -rf /koolshare/xunyou
    mkdir -p /koolshare/xunyou
    #
    rm -rf /koolshare/init.d/S90XunYouAcc.sh > /dev/null 2>&1
    rm -rf /koolshare/scripts/xunyou_status.sh > /dev/null 2>&1
    #
    cp -rf /tmp/${MODULE}/webs/* /koolshare/webs/
    cp -rf /tmp/${MODULE}/res/*  /koolshare/res/
    cp -rf /tmp/${MODULE}/*      /koolshare/xunyou/
    cp -rf /tmp/${MODULE}/uninstall.sh  /koolshare/scripts/uninstall_xunyou.sh
    #
    chmod +x /koolshare/xunyou/bin/*
    chmod +x /koolshare/xunyou/scripts/*
    #
    ln -sf /koolshare/xunyou/scripts/${MODULE}_config.sh /koolshare/init.d/S90XunYouAcc.sh
    ln -sf /koolshare/xunyou/scripts/${MODULE}_config.sh /koolshare/scripts/xunyou_status.sh
    #
    dbus set ${MODULE}_version="${VERSION}"
    dbus set ${MODULE}_title="${title}"
    [ "${enable}" != "1" ] && dbus set ${MODULE}_enable="0"
    dbus set softcenter_module_${MODULE}_install=1
    dbus set softcenter_module_${MODULE}_name=${MODULE}
    dbus set softcenter_module_${MODULE}_version="${VERSION}"
    dbus set softcenter_module_${MODULE}_title="${title}"
    dbus set softcenter_module_${MODULE}_description="迅游加速器，支持PC和主机加速。"
    #
    [ "${enable}" == "1" ] &&  sh /koolshare/xunyou/scripts/${MODULE}_config.sh
}

official_install()
{
    if [ ! -d "/jffs/xunyou" ];then
        ret=`mkdir -p /jffs/xunyou`
        [ -n "${ret}" ] && echo [`date +"%Y-%m-%d %H:%M:%S"`] "创建安装路径失败！" && return 1
    fi
    #
    rm -rf /etc/init.d/S90XunYouAcc.sh > /dev/null 2>&1
    cp -rf /tmp/${MODULE}/*      /jffs/xunyou/
    #
    chmod +x /jffs/xunyou/bin/*
    chmod +x /jffs/xunyou/scripts/*
    ln -sf /jffs/xunyou/scripts/${MODULE}_config.sh /etc/init.d/S90XunYouAcc.sh
    /jffs/xunyou/scripts/${MODULE}_config.sh
}

case ${systemType} in
    0)
        koolshare_install
        ;;
    1)
        official_install
        ;;
    2)
        ;;
    *)
        ;;
esac

remove_install_file

exit 0
