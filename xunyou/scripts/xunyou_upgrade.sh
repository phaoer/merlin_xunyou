#!/bin/sh
#参数1 =0 准备下载环境
#参数1 =1 解压升级包 ;参数2:待解压文件
#参数1 =3 备份原有配置以及程序;参数2：程序路径;参数3:程序名
#参数1 =4 升级程序，替换原有程序 ;参数2:待替换程序路径;参数3:升级程序名
#参数1 =5 reback  程序
#参数1 =6 restart 程序;参数2：程序路径;参数3:程序名
#参数1 =7 获取设备型号和固件版本号
if [ "$1" = "0" ]; then
    if [ ! -d "/tmp/upgrade" ];then
			mkdir $file_path
	fi
elif [ "$1" = "1" ]; then
    if [ -e "/tmp/upgrade/$2" ];then 
        cd /tmp/upgrade && tar -xf $2
    fi
elif [ "$1" = "3" ]; then
    if [ -e "$2/$3" ];then
        cp -f "$2/$3" "$2/$3.bak"
    fi
elif [ "$1" = "4" ]; then
    if [ -e "$2/$3" ];then
        rm -f "$2/$3"
        cp -f /tmp/upgrade/$3 "$2/$3"
    fi
elif [ "$1" = "5" ]; then
    if [ -e "$2/$3.bak" ];then
        cp -f "$2/$3.bak" "$2/$3"
        rm -rf "$2/$3.bak"
    fi
elif [ "$1" = "6" ]; then
    echo "restart the program" >1
    sh /koolshare/xunyou/scripts/xunyou_config.sh start
elif [ "$1" = "7" ]; then
    if [ -d "/koolshare" ];then
        product_id=`nvram get odmpid`
        product_version=`nvram get buildno`
        echo -n $product_version/ >/tmp/version
    else
        product_id=`nvram get productid`
        product_version=`nvram get innerver`
        echo -n $product_version/ >/tmp/version
    fi
fi
