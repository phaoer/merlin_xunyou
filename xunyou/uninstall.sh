#!/bin/bash
MODULE=xunyou
title="迅游加速器"
VERSION="1.0.0.1"
module="xunyou_acc"

eval `dbus export xunyou_`
source /koolshare/scripts/base.sh

sh /koolshare/xunyou/scripts/${MODULE}_config.sh stop

values=`dbus list xunyou_ | cut -d "=" -f 1`

for value in $values
do
    dbus remove $value
done

cru d ${module}

rm -rf /koolshare/scripts/xunyou_status.sh
rm -rf /koolshare/init.d/S90XunYouAcc.sh
rm -rf /koolshare/xunyou
rm -rf /koolshare/res/icon-xunyou.png
rm -rf /koolshare/webs/Module_xunyou.asp
rm -rf /koolshare/scripts/uninstall_xunyou.sh
