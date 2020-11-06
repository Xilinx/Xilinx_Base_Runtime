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
    echo "  <version>        : 2018.3 / 2019.1 / 2019.2 / 2020.1"
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
    echo "Support Platform                   Version      OS Version"
    echo "Alveo U200 / U250                  2018.3       CentOS"
    echo "Alveo U200 / U250                  2018.3       Ubuntu 16.04"
    echo "Alveo U200 / U250                  2018.3       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280           2019.1       CentOS"
    echo "Alveo U200 / U250 / U280           2019.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280           2019.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 /u50      2019.2       CentOS"
    echo "Alveo U200 / U250 / U280 /u50      2019.2       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 /u50      2019.2       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 /u50      2020.1       CentOS"
    echo "Alveo U200 / U250 / U280 /u50      2020.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 /u50      2020.1       Ubuntu 18.04"
}

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
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
        XRT_VERSION=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $8}' | awk -F= '{print $2}'`
        if [[ "$PLATFORM" == "alveo-u50" ]]; then
            CMC_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $9}' | awk -F= '{print $2}'`
            SC_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $10}' | awk -F= '{print $2}'`
            SHELL_TARBALL=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $11}' | awk -F= '{print $2}'`
        fi
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
        apt update
        apt install python3-pip
        pip3 install --upgrade pip
        pip3 install pyopencl==2020.1
        apt-get install --reinstall /tmp/$XRT_PACKAGE
    elif [[ "$OSVERSION" == "centos" ]]; then
        XRT_VERSION_INSTALLED=`yum info installed xrt 2> /dev/null | grep Version`
        if [[ $? == 0 ]]; then
            XRT_VERSION_INSTALLED=`echo "$XRT_VERSION_INSTALLED" | cut -d ":" -f2| cut -d " " -f2`
            XRT_VERSION_INSTALLED=`echo "${XRT_VERSION_INSTALLED/-/.}"`
            vercomp $XRT_VERSION_INSTALLED $XRT_VERSION
            case $? in
                0) yum reinstall /tmp/$XRT_PACKAGE;;
                1) yum downgrade /tmp/$XRT_PACKAGE;;
                2) yum install /tmp/$XRT_PACKAGE;;
            esac
        else
            yum install epel-release
            yum install /tmp/$XRT_PACKAGE
        fi
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
    if [[ "$PLATFORM" == "alveo-u50" ]]; then
        flash_cards_u50
        return 
    fi
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Download Shell package"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE

        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            apt-get install /tmp/$SHELL_PACKAGE
        elif [[ "$OSVERSION" == "centos" ]]; then
            yum remove -y $PACKAGE_NAME
            yum install /tmp/$SHELL_PACKAGE
        fi
        rm /tmp/$SHELL_PACKAGE
    else
        echo "The package is already installed. "
    fi
    
    echo "Flash Card(s). "
    if [[ "$VERSION" == "2018.3" ]]; then
        /opt/xilinx/xrt/bin/xbutil flash -a $DSA  $TIMESTAMP 
    elif [[ "$VERSION" == "2019.1" ]]; then
        /opt/xilinx/xrt/bin/xbmgmt flash -a $DSA  $TIMESTAMP
    elif [[ "$VERSION"  == "2019.2" || "$VERSION"  == "2020.1" ]]; then
        /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
    fi
}

flash_cards_u50() {
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Download Shell package"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_TARBALL" > /tmp/$SHELL_TARBALL

        # Unpack tarball
        tar -zxvf /tmp/$SHELL_TARBALL -C /tmp
        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            apt-get install --reinstall /tmp/$CMC_PACKAGE
            apt-get install --reinstall /tmp/$SC_PACKAGE
            apt-get install --reinstall /tmp/$SHELL_PACKAGE
        elif [[ "$OSVERSION" == "centos" ]]; then
            yum remove -y xilinx-cmc-u50 xilinx-sc-fw-u50
            yum install /tmp/$CMC_PACKAGE
            yum install /tmp/$SC_PACKAGE
            yum install /tmp/$SHELL_PACKAGE
        fi
        rm /tmp/$SHELL_PACKAGE /tmp/$CMC_PACKAGE /tmp/$SC_PACKAGE /tmp/$SHELL_PACKAGE
    else
        echo "The package is already installed. "
    fi

    echo "Flash Card(s). "
    /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
}

notice_disclaimer() {
    cat doc/notice_disclaimer.txt
}

detect_cards() {
    lspci > /dev/null
    if [ $? != 0 ] ; then
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
            apt-get install -y pciutils
        elif [[ "$OSVERSION" == "centos" ]]; then
            yum install -y pciutils
        fi
    fi

    for DEVICE_ID in $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f7); do
        if [[ "$DEVICE_ID" == "5000" ]] || [[ "$DEVICE_ID" == "d000" ]]; then
            U200=$((U200 + 1))
        elif [[ "$DEVICE_ID" == "5004" ]] || [[ "$DEVICE_ID" == "d004" ]]; then
            U250=$((U250 + 1))
        elif [[ "$DEVICE_ID" == "5008" ]] || [[ "$DEVICE_ID" == "d008" ]] || [[ "$DEVICE_ID" == "500c" ]] || [[ "$DEVICE_ID" == "d00c" ]]; then
            U280=$((U280 + 1))
        elif [[ "$DEVICE_ID" == "5020" ]] || [[ "$DEVICE_ID" == "d020" ]]; then
            U50=$((U50 + 1))
        fi
    done
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
PLATFORM_ONLY="NONE"
INSTALL_DOCKER=0
U200=0
U250=0
U280=0
U50=0

notice_disclaimer
confirm 

while true
do
case "$1" in
    --skip-xrt-install   ) XRT=0             ; shift 1 ;;
    --skip-shell-flash   ) SHELL=0           ; shift 1 ;;
    -v|--version         ) VERSION="$2"      ; shift 2 ;;
    -p|--platform        ) PLATFORM_ONLY="$2"; shift 2 ;;
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

echo $PATH | grep -q  "/your/search/path"
if [[ $? != 0 ]]; then
    export PATH=$PATH:"/usr/local/sbin"
fi
echo $PATH | grep -q  "/usr/sbin"
if [[ $? != 0 ]]; then
    export PATH=$PATH:"/usr/sbin"
fi
echo $PATH | grep -q  "/sbin"
if [[ $? != 0 ]]; then
    export PATH=$PATH:"/sbin"
fi

if [[ "$INSTALL_DOCKER" == 1 ]]; then
    ./utilities/docker_install.sh
fi

if [[ "$XRT" == 0 &&  "$SHELL" == 0 ]] ; then echo "Please do NOT skip both XRT installation and card flashing." >&2 ; usage; exit 1 ; fi

detect_cards

if [[ "$XRT" == 1 ]]; then
    get_packages
    install_xrt
fi

if [[ "$SHELL" == 1 ]]; then

    if [[ "$U200" == 0 && "$U250" == 0 && "$U280" == 0 && "$U50" == 0 ]]; then
        echo "[WARNING] No FPGA Board Detected. Skip shell flash."
        exit 0;
    fi

    if [[ "$PLATFORM_ONLY" != "NONE" ]]; then
        PF=`echo $PLATFORM_ONLY | awk -F'-' '{print $2}' | awk '{print toupper($0)}'`
        if [[ "$(($PF))" == 0 ]]; then
            echo "[Error]: You don't have $PF card! "
            exit 1
        fi
        echo "You have $(($PF)) $PF card(s). "
        PLATFORM=`echo $PLATFORM_ONLY`
        # echo $PLATFORM
        flash_cards
    else
        for PF in U200 U250 U280 U50; do
            if [[ "$(($PF))" != 0 ]]; then
                echo "You have $(($PF)) $PF card(s). "
                PLATFORM=`echo "alveo-$PF" | awk '{print tolower($0)}'`
                # echo $PLATFORM
                flash_cards
            fi
        done
    fi
    
fi

