#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
    echo "Running host_setup.sh to install XRT and flash Shell on host machine. "
    echo ""
    echo "Usage:"
    echo "  ./host_setup.sh --version <version>"
    echo "  ./host_setup.sh  -v       <version>"
    echo "  <version>        : 2018.3 / 2019.1 / 2019.2"
    echo "  --skip-xrt-install    : skip install XRT"
    echo "  --skip-shell-flash    : skip flash Shell"
    echo "  --install-docker      : install docker serveice"
    echo ""
    echo "Example:"
    echo "Install 2019.2 XRT and flash Shell "
    echo "  ./host_setup.sh -v 2019.2"

}

list() {
    echo ""
    echo "Support Platform              Version      OS Version"
    echo "Alveo U200 / U250             2018.3       CentOS"
    echo "Alveo U200 / U250             2018.3       Ubuntu 16.04"
    echo "Alveo U200 / U250             2018.3       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280      2019.1       CentOS"
    echo "Alveo U200 / U250 / U280      2019.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280      2019.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280      2019.2       CentOS"
    echo "Alveo U200 / U250 / U280      2019.2       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280      2019.2       Ubuntu 18.04"
}

get_packages() {
    COMB="${PLATFORM}_${VERSION}_${OSVERSION}"

    if grep -q $COMB "conf/spec.txt"; then
        XRT_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $1}' | awk -F= '{print $2}'`
        SHELL_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $2}' | awk -F= '{print $2}'`
        DSA=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $3}' | awk -F= '{print $2}'`
        TIMESTAMP=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $4}' | awk -F= '{print $2}'`
        PACKAGE_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $6}' | awk -F= '{print $2}'`
        PACKAGE_VERSION=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $7}' | awk -F= '{print $2}'`
    else
        usage
        echo ""
        list
        exit 1
    fi
}

install_xrt() {
    echo "Download XRT installation package"
    wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$XRT_PACKAGE" > /tmp/$XRT_PACKAGE

    echo "Install XRT"
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        apt-get install --reinstall /tmp/$XRT_PACKAGE
    elif [[ "$OSVERSION" == "centos" ]]; then
        XRT_VERSION=`yum info xrt 2> /dev/null | grep Version`
        if [[ $? == 0 ]]; then
            yum remove -y xrt
        fi
        yum install epel-release
        yum install /tmp/$XRT_PACKAGE
    fi
    rm /tmp/$XRT_PACKAGE
}

check_packages() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        PACKAGE_INSTALL_INFO=`apt list --installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    elif [[ "$OSVERSION" == "centos" ]]; then
        PACKAGE_INSTALL_INFO=`yum list installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    fi
}

flash_cards() {
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Download Shell package"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE

        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            apt-get install /tmp/$SHELL_PACKAGE
        elif [[ "$OSVERSION" == "centos" ]]; then
            rpm -i /tmp/$SHELL_PACKAGE
        fi
        rm /tmp/$SHELL_PACKAGE
    fi
    
    if [[ "$VERSION" == "2018.3" ]]; then
        /opt/xilinx/xrt/bin/xbutil flash -a $DSA  $TIMESTAMP 
    elif [[ "$VERSION" == "2019.1" ]]; then
        /opt/xilinx/xrt/bin/xbmgmt flash -a $DSA  $TIMESTAMP
    elif [[ "$VERSION"  == "2019.2" ]]; then
        /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
    fi
}

notice_disclaimer() {
    cat doc/notice_disclaimer.txt
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure you wish to proceed? [y/n]:} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            exit 1
            ;;
    esac
}

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

XRT=1
SHELL=1
PLATFORM="alveo-u200"
VERSION="NONE"
INSTALL_DOCKER=0

notice_disclaimer
confirm 

while true
do
case "$1" in
    --skip-xrt-install   ) XRT=0             ; shift 1 ;;
    --skip-shell-flash   ) SHELL=0           ; shift 1 ;;
    -v|--version         ) VERSION="$2"      ; shift 2 ;;
    --install-docker     ) INSTALL_DOCKER=1  ; shift 1 ;;
    -h|--help            ) usage             ; exit  1 ;;
    ""                   ) break ;;
*) echo "invalid option: $1"; usage; exit 1 ;;
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

wget --help > /dev/null
if [ $? != 0 ] ; then
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
        apt-get install -y wget
    elif [[ "$OSVERSION" == "centos" ]]; then
        yum install -y wget
    fi
fi


if [[ "$INSTALL_DOCKER" == 1 ]]; then
    ./utilities/docker_install.sh
fi

if [[ "$XRT" == 0 &&  "$SHELL" == 0 ]] ; then echo "Please do NOT skip both XRT installation and card flashing." >&2 ; usage; exit 1 ; fi

if [[ "$XRT" == 1 ]]; then
    get_packages
    install_xrt
fi

if [[ "$SHELL" == 1 ]]; then

    lspci > /dev/null
    if [ $? != 0 ] ; then
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            apt-get install -y pciutils
        elif [[ "$OSVERSION" == "centos" ]]; then
            yum install -y pciutils
        fi
    fi

    U200=0
    U250=0
    U280=0
    for DEVICE_ID in $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f7); do
        if [[ "$DEVICE_ID" == "5000" ]]; then
            U200=$((U200 + 1))
        elif [[ "$DEVICE_ID" == "5004" ]]; then
            U250=$((U250 + 1))
        elif [[ "$DEVICE_ID" == "5008" ]]; then
            U280=$((U280 + 1))
        fi
    done

    if [[ "$U200" == 0 && "$U250" == 0 && "$U280" == 0 ]]; then
        echo "[ERROR] No FPGA Board Detected. You need at least one FPGA board to use this script."
        list
        exit 1;
    fi

    if [[ "$U200" != 0 ]]; then
        echo "You have $U200 U200 card(s)."
        read -r -p "${1:-Do you want to flash U200 card(s)? [y/n]:} " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                PLATFORM="alveo-u200" 
                flash_cards
                ;;
            *) echo "Skip flash U200 card(s). " ;;
        esac
    fi

    if [[ "$U250" != 0 ]]; then
        echo "You have $U250 U250 card(s)."
        read -r -p "${1:-Do you want to flash U250 card(s)? [y/n]:} " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                PLATFORM="alveo-u250" 
                flash_cards
                ;;
            *) echo "Skip flash U250 card(s). ";;
        esac
    fi

    if [[ "$U280" != 0 ]]; then
        echo "You have $U280 U280 card(s)."
        read -r -p "${1:-Do you want to flash U280 card(s)? [y/n]:} " response
        case "$response" in
            [yY][eE][sS]|[yY])
                PLATFORM="alveo-u280" 
                flash_cards 
                ;;
            *) echo "Skip flash U250 card(s). ";;
        esac
    fi
    
fi

