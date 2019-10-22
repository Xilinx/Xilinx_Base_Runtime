#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
    echo "Running host_setup.sh to install XRT and flash Shell on host machine. "
    echo ""
    echo "Usage:"
    echo "  ./host_setup.sh --platform <platform> --version <version>"
    echo "  ./host_setup.sh  -p <platform>         -v       <version>"
    echo "  <platform>       : alveo-u200 / alveo-u250 / alveo-u280"
    echo "  <version>        : 2018.3 / 2019.1"
    echo "  --skip-xrt-install    : skip install XRT"
    echo "  --skip-shell-flash    : skip flash Shell"
    echo ""
    echo "Example:"
    echo "Install 2019.1 XRT for Alveo U200 and flash Shell "
    echo "  ./install.sh -p alveo-u200 -v 2019.1"

}

list() {
    echo "Available Docker Images:"
    echo ""
    echo "Image Name                          Platform         Version      OS Version"
    echo "alveo-u200-201830-centos            Alveo U200       2018.3       CentOS"
    echo "alveo-u200-201830-ubuntu-1604       Alveo U200       2018.3       Ubuntu 16.04"
    echo "alveo-u200-201830-ubuntu-1804       Alveo U200       2018.3       Ubuntu 18.04"
    echo "alveo-u200-2019-1-centos            Alveo U200       2019.1       CentOS"
    echo "alveo-u200-2019-1-ubuntu-1604       Alveo U200       2019.1       Ubuntu 16.04"
    echo "alveo-u200-2019-1-ubuntu-1804       Alveo U200       2019.1       Ubuntu 18.04"
    echo "alveo-u250-201830-centos            Alveo U250       2018.3       CentOS"
    echo "alveo-u250-201830-ubuntu-1604       Alveo U250       2018.3       Ubuntu 16.04"
    echo "alveo-u250-201830-ubuntu-1804       Alveo U250       2018.3       Ubuntu 18.04"
    echo "alveo-u250-2019-1-centos            Alveo U250       2019.1       CentOS"
    echo "alveo-u250-2019-1-ubuntu-1604       Alveo U250       2019.1       Ubuntu 16.04"
    echo "alveo-u250-2019-1-ubuntu-1804       Alveo U250       2019.1       Ubuntu 18.04"
    echo "alveo-u280-2019-1-centos            Alveo U280       2019.1       CentOS"
    echo "alveo-u280-2019-1-ubuntu-1604       Alveo U280       2019.1       Ubuntu 16.04"
    echo "alveo-u280-2019-1-ubuntu-1804       Alveo U280       2019.1       Ubuntu 18.04"
}


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

XRT=1
SHELL=1

while true
do
case "$1" in
    --skip-xrt-install   ) XRT=0             ; shift 1 ;;
    --skip-shell-flash   ) SHELL=0           ; shift 1 ;;
    -p|--platform        ) PLATFORM="$2"     ; shift 2 ;;
    -v|--version         ) VERSION="$2"      ; shift 2 ;;
    -h|--help            ) usage             ; exit  1 ;;
*) break ;;
esac
done

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

OSVERSION=`grep '^ID=' /etc/os-release | awk -F= '{print $2}'`
OSVERSION=`echo $OSVERSION | tr -d '"'`
if [[ "$OSVERSION" == "ubuntu" ]]; then
    VERSION_ID=`grep '^VERSION_ID=' /etc/os-release | awk -F= '{print $2}'`
    VERSION_ID=`echo $VERSION_ID | tr -d '"'`
    OSVERSION="$OSVERSION-$VERSION_ID"
fi


if [[ "$PLATFORM" == "alveo-u200" ]]; then
    if [[ "$VERSION" == "2018.3" ]]; then
        if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_18.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_18.04.deb"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1804"
        elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_16.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_16.04.deb"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1604"
        elif [[ "$OSVERSION" == "centos" ]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_7.4.1708-xrt.rpm"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015.x86_64.rpm"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-centos"
        else
            echo "Unsupported Operating System! "
            usage
            echo ""
            list
            exit 1
        fi
    elif [[ "$VERSION" == "2019.1" ]]; then
        if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_18.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_18.04.deb"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1804"
        elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_16.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_16.04.deb"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1604"
        elif [[ "$OSVERSION" == "centos" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_7.4.1708-xrt.rpm"
            SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015.x86_64.rpm"
            DSA="xilinx_u200_xdma_201830_2"
            TIMESTAMP="-t 1561465320"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-centos"
        else
            echo "Unsupported Operating System! "
            usage
            echo ""
            list
            exit 1
        fi
    else
        echo "Unsupported version! "
        usage
        echo ""
        list
        exit 1
    fi
elif [[ "$PLATFORM" == "alveo-u250" ]]; then
    if [[ "$VERSION" == "2018.3" ]]; then
        if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_18.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_18.04.deb"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1804"
        elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_16.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_16.04.deb"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1604"
        elif [["$OSVERSION" == "centos"]]; then
            XRT_PACKAGE="xrt_201830.2.1.1794_7.4.1708-xrt.rpm"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015.x86_64.rpm"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-centos"
        else
            echo "Unsupported Operating System! "
            usage
            echo ""
            list
            exit 1
        fi
    elif [[ "$VERSION" == "2019.1" ]]; then
        if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_18.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_18.04.deb"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1804"
        elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_16.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_16.04.deb"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1604"
        elif [["$OSVERSION" == "centos"]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_7.4.1708-xrt.rpm"
            SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015.x86_64.rpm"
            DSA="xilinx_u250_xdma_201830_2"
            TIMESTAMP="-t 1561656294"
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-centos"
        else
            echo "Unsupported Operating System! "
            usage
            echo ""
            list
            exit 1
        fi
    else
        echo "Unsupported version! "
        usage
        echo ""
        list
        exit 1
    fi
elif [[ "$PLATFORM" == "alveo-u280" ]]; then
    if [[ "$VERSION" == "2019.1" ]]; then
        if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_18.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327_18.04.deb"
            DSA="xilinx_u280_xdma_201910_1"
            TIMESTAMP=""
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1804"
        elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_16.04-xrt.deb"
            SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327_16.04.deb"
            DSA="xilinx_u280_xdma_201910_1"
            TIMESTAMP=""
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1604"
        elif [["$OSVERSION" == "centos"]]; then
            XRT_PACKAGE="xrt_201910.2.2.2250_7.4.1708-xrt.rpm"
            SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327.x86_64.rpm"
            DSA="xilinx_u280_xdma_201910_1"
            TIMESTAMP=""
            DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-centos"
        else
            echo "Unsupported Operating System! "
            usage
            echo ""
            list
            exit 1
        fi
    else
        echo "Unsupported version! "
        usage
        echo ""
        list
        exit 1
    fi
else
    echo "Unsupported platform! "
    usage
    echo ""
    list
    exit 1
fi

wget --help > /dev/null
if [ $? != 0 ] ; then
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        apt-get install -y wget
    elif [[ "$OSVERSION" == "centos" ]]; then
        yum install -y wget
fi


if [ "$XRT" == 0 &&  "$SHELL" == 1] ; then echo "Please select XRT or Shell or both to install." >&2 ; usage; exit 1 ; fi


if [[ "$XRT" == 1 ]]; then
    echo "Download XRT installation package"
    wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$XRT_PACKAGE" > /tmp/$XRT_PACKAGE

    echo "Install XRT"
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        apt-get install --reinstall /tmp/$XRT_PACKAGE
    # elif [[ "$OSVERSION" == "redhat" ]]; then
    #       yum-config-manager --enable rhel-7-server-optional-rpms
    #       yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    elif [[ "$OSVERSION" == "centos" ]]; then
        yum install epel-release
        yum install /tmp/$XRT_PACKAGE
    fi
    rm /tmp/$XRT_PACKAGE
fi

if [[ "$SHELL" == 1 ]]; then
    echo "Download Shell package"
    wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE

    echo "Install Shell"
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        apt-get install /tmp/$SHELL_PACKAGE
    elif [[ "$OSVERSION" == "centos" ]]; then
        rpm -i /tmp/$SHELL_PACKAGE
    fi
    rm /tmp/$SHELL_PACKAGE
    
    echo "Flash Card"
    /opt/xilinx/xrt/bin/xbutil flash -a $DSA  $TIMESTAMP
fi
