#!/bin/bash
MODULE=xunyou
title="迅游加速器"
VERSION="1.0.0.1"

eval `dbus export xunyou_`
source /koolshare/scripts/base.sh

enable=`dbus get ${MODULE}_enable`
if [ "${enable}" == "1" ];then
    sh /koolshare/xunyou/scripts/${MODULE}_status.sh stop
fi

values=`dbus list xunyou_ | cut -d "=" -f 1`

for value in $values
do
    dbus remove $value
done

rm -rf /koolshare/scripts/xunyou_status.sh
rm -rf /koolshare/init.d/S90XunYouAcc.sh
rm -rf /koolshare/xunyou
rm -rf /koolshare/res/icon-xunyou.png
rm -rf /koolshare/webs/Module_xunyou.asp