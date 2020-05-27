#!/bin/bash
MODULE=xunyou
title="迅游加速器"
VERSION="1.0.0.1"


remove_install_file(){
	rm -rf /tmp/${MODULE}* >/dev/null 2>&1
}

case $(uname -m) in
    aarch64)
        ;;

    *)
        echo [`date +"%Y-%m-%d %H:%M:%S"`] "本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！"
        echo [`date +"%Y-%m-%d %H:%M:%S"`] "退出安装！"
        remove_install_file
        exit 1
        ;;
esac

enable=`dbus get ${MODULE}_enable`
if [ "${enable}" == "1" ];then
    sh /koolshare/xunyou/scripts/${MODULE}_config.sh stop
fi

cd /tmp

mkdir /koolshare/xunyou >/dev/null 2>&1
#
rm -rf /koolshare/init.d/S90XunYouAcc.sh
cp -rf /tmp/${MODULE}/webs/* /koolshare/webs/
cp -rf /tmp/${MODULE}/res/*  /koolshare/res/
cp -rf /tmp/${MODULE}/*      /koolshare/xunyou/
cp -rf /tmp/${MODULE}/uninstall.sh  /koolshare/scripts/uninstall_xunyou.sh


chmod +x /koolshare/xunyou/bin/*
chmod +x /koolshare/xunyou/scripts/*
[ ! -L "/koolshare/init.d/S90XunYouAcc.sh" ] && ln -sf /koolshare/xunyou/scripts/${MODULE}_config.sh /koolshare/init.d/S90XunYouAcc.sh


dbus set ${MODULE}_version="${VERSION}"
dbus set ${MODULE}_title="${title}"
dbus set ${MODULE}_enable="0"
dbus set softcenter_module_${MODULE}_install=1
dbus set softcenter_module_${MODULE}_name=${MODULE}
dbus set softcenter_module_${MODULE}_version="${VERSION}"
dbus set softcenter_module_${MODULE}_title="${title}"
dbus set softcenter_module_${MODULE}_description="迅游加速器，支持PC和主机加速。"


if [ "${enable}" == "1" ];then
    sh /koolshare/scripts/${MODULE}_config.sh start
fi

remove_install_file

exit 0
