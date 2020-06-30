#!/bin/sh
#参数1 =0 准备下载环境
#参数1 =1 解压升级包 ;参数2:待解压文件
#参数1 =3 备份原有配置以及程序;参数2：程序路径;参数3:程序名
#参数1 =4 升级程序，替换原有程序 ;参数2:待替换程序路径;参数3:升级程序名
#参数1 =5 reback  程序
#参数1 =6 restart 程序;参数2：程序路径;参数3:程序名
#参数1 =7 获取设备型号和固件版本号

xunyouPath=""
systemType=0

if [ -d "/koolshare" ];then
    xunyouPath="/koolshare"
    systemType=0
else
    xunyouPath="/jffs"
    systemType=1
    [ ! -d "/jffs" ] && exit 1
fi

get_route_info()
{
    if [ -d "/koolshare" ];then
        product_arch=`uname -m`
        product_id=`nvram get odmpid`
        if [ -z ${product_id} ];then
		    product_id=`nvram get productid`
		    #echo ${product_id}
	    fi
        if [ -z ${product_id} ];then
            product_id="unknow"
        fi
        if [ ! -z ${product_arch} ];then
            if [ ${product_arch} =  "aarch64" ];then
                product_arch="arm-8"
            elif [ ${product_arch} =  "armv7hl"  ];then
                product_arch="arm-7"
            elif [ ${product_arch} =  "armv5tel"  ];then
                product_arch="arm-5"
            fi
        fi
        product_version=`nvram get buildno`
        
        if [ ${product_id} =  "RT-AX82U" -o  ${product_id} =  "TUF-AX3000" ];then
            product_arch="arm-8"
            product_version="384"
        fi
        str="$product_version"
        substr=${str%.*}
        product_version=$substr
        echo -n ${product_arch}/$product_version/ >/tmp/version
    else
        product_arch=`uname -m`
        product_id=`nvram get productid`
        if [ -z ${product_id} ];then
		    product_id=`nvram get odmpid`
		    #echo ${product_id}
	    fi
        if [ -z ${product_id} ];then
            product_id="unknow"
        fi
        if [ ! -z ${product_arch} ];then
            if [ ${product_arch} =  "aarch64" ];then
                product_arch="arm-8"
            elif [ ${product_arch} =  "armv7hl"  ];then
                product_arch="arm-7"
            elif [ ${product_arch} =  "armv5tel"  ];then
                product_arch="arm-5"
            fi
        fi
        product_version=`nvram get buildno`
        if [ ${product_id} =  "RT-AX82U" -o ${product_id} =  "TUF-AX3000" ];then
            product_arch="arm-8"
            product_version="384"
        fi
        str="$product_version"
        substr=${str%.*}
        product_version=$substr
        echo -n ${product_arch}/$product_version/ >/tmp/version
    fi
}


case $1 in
    0)
        [ ! -d "/tmp/" ] && mkdir -p /tmp/
        ;;
    1)
        [ -e "/tmp/$2" ] && cd /tmp/ && tar -xzf $2
        ;;
    3)
        [ -e "$2/$3" ] && cp -f "$2/$3" "$2/$3.bak"
        ;;
    4)
        [ -e "$2/$3" ] && rm -f "$2/$3"
        cp -f /tmp/xunyou/bin/$3 "$2/$3"
        ;;
    5)
        [ ! -e "$2/$3.bak" ] && exit 0
        cp -f "$2/$3.bak" "$2/$3"
        rm -rf "$2/$3.bak"
        ;;
    6)
        echo "restart the program"
        [ ！ -d "/tmp/xunyou" ] && exit 0
        sh ${xunyouPath}/scripts/uninstall_xunyou.sh
        sh /tmp/xunyou/install.sh
        [ ${systemType} -eq 0] && dbus set xunyou_enable=1
        sh ${xunyouPath}/scripts/xunyou_status.sh install
        sh ${xunyouPath}/scripts/xunyou_status.sh stop
        sh ${xunyouPath}/scripts/xunyou_status.sh start
        ;;
    7)
        get_route_info
        ;;
    *)
        ;;
esac
