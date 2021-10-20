#!/usr/bin/env bash
#
# (C) Copyright 2021, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
    echo "Running host_setup.sh to install XRT and flash Shell on host machine. "
    echo ""
    echo "Usage:"
    echo "  ./host_setup.sh --version <version>"
    echo "  ./host_setup.sh  -v       <version>"
    echo "  <version>        : 2018.3 / 2019.1 / 2019.2 / 2020.1 / 2020.2"
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
    echo "Alveo U200 / U250                  2018.3       CentOS 7"
    echo "Alveo U200 / U250                  2018.3       Ubuntu 16.04"
    echo "Alveo U200 / U250                  2018.3       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280           2019.1       CentOS 7"
    echo "Alveo U200 / U250 / U280           2019.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280           2019.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50     2019.2       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50     2019.2       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 / U50     2019.2       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50     2020.1       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50     2020.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 / U50     2020.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50     2020.2       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50     2020.2       CentOS 8"
    echo "Alveo U200 / U250 / U280 / U50     2020.2       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 / U50     2020.2       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50     2021.1       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50     2021.1       CentOS 8"
    echo "Alveo U200 / U250 / U280 / U50     2021.1       Ubuntu 16.04"
    echo "Alveo U200 / U250 / U280 / U50     2021.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U50            2021.1       Ubuntu 20.04"
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
        if [[ "$PLATFORM" == "alveo-u250" ]]; then
            CMC_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $9}' | awk -F= '{print $2}'`
            SC_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $10}' | awk -F= '{print $2}'`
            SHELL_TARBALL=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $11}' | awk -F= '{print $2}'`
            VALIDATE_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $12}' | awk -F= '{print $2}'`
            2RP_SHELL_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $13}' | awk -F= '{print $2}'`
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

    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        dpkg -s xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`dpkg -s xrt | grep Version | cut -d' ' -f 2`
            if [[ "$CURRENT_XRT_VERSION" != "$XRT_VERSION" ]]; then
                while true; do
                    read -p "Current XRT Version: $CURRENT_XRT_VERSION. REMOVE PREVIOUS XRT? (Y/N)" yn # Prompt user with which version will be removed
                    case $yn in
                        [Yy]* ) remove_xrt; break;;
                        [Nn]* ) multiple_xrt; break;;
                        * ) echo "Please answer Y or N";;
                    esac
                done
            else
                echo "You already have this version of XRT ($XRT_VERSION) installed"
                return
            fi
        else
            apt update
            apt install -y python3-pip
            pip3 install --upgrade pip
            pip3 install pyopencl==2020.1
            apt-get install -y --reinstall /tmp/$XRT_PACKAGE
        fi
    elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
        rpm -q xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`rpm -q xrt | cut -d'-' -f 2`
            if [[ "$CURRENT_XRT_VERSION" != "$XRT_VERSION" ]]; then
                while true; do
                    read -p "Current XRT Version: $CURRENT_XRT_VERSION. REMOVE PREVIOUS XRT? (Y/N)" yn # Prompt user with which version will be removed
                    case $yn in
                        [Yy]* ) remove_xrt; break;;
                        [Nn]* ) multiple_xrt; break;;
                        * ) echo "Please answer Y or N";;
                    esac
                done
            else
                echo "You already have this version of XRT ($XRT_VERSION) installed"
                return
            fi
        else
            if [[ "$OSVERSION" == "centos-7" ]] ; then
                yum install -y epel-release
                yum install -y /tmp/$XRT_PACKAGE
            elif [[ "$OSVERSION" == "centos-8" ]]; then
                yum config-manager --set-enabled PowerTools
                yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
                yum config-manager --set-enabled AppStream
                yum install -y /tmp/$XRT_PACKAGE
            fi
        fi
    fi
    rm /tmp/$XRT_PACKAGE
}

check_packages() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        PACKAGE_INSTALL_INFO=`apt list --installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
        PACKAGE_INSTALL_INFO=`yum list installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    fi
}

remove_xrt() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [["$OSVERSION" == "ubuntu-20.04"]]; then
        while true; do
            read -p "REMOVE XRT WITH DEPENDENCIES? (Y/N)" yn
            case $yn in
                [Yy]* ) dpkg -r xrt; break;;
                [Nn]* ) dpkg -r --force-depends xrt; break;;
                * ) echo "Please answer Y or N";;
            esac
        done
        apt-get install -y /tmp/$XRT_PACKAGE
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        while true; do
            read -p "REMOVE XRT WITH DEPENDENCIES? (Y/N)" yn
            case $yn in
                [Yy]* ) yum remove xrt; break;;
                [Nn]* ) rpm -e --nodeps xrt; break;;
                * ) echo "Please answer Y or N";;
            esac
        done
        yum install -y /tmp/$XRT_PACKAGE
    elif [[ "$OSVERSION" == "centos-8" ]]; then
        while true; do
            read -p "REMOVE XRT WITH DEPENDENCIES? (Y/N)" yn
            case $yn in
                [Yy]* ) yum remove xrt; break;;
                [Nn]* ) yum remove --notautoremove xrt; break;;
                * ) echo "Please answer Y or N";;
            esac
        done
        yum install -y /tmp/$XRT_PACKAGE
    fi
}

multiple_xrt() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        while true; do
            read -p "MULTIPLE XRT VERSIONS WILL EXIST ON YOUR SYSTEM. PROCEED? (Y/N)" yn
            case $yn in
                [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION}; # Add what will be the result if they choose yes
                        apt update; # Old XRT version has been renamed, new XRT version is now default
                        apt install -y python3-pip;
                        pip3 install --upgrade pip;
                        pip3 install pyopencl==2020.1;
                        echo "Install XRT Version: $XRT_PACKAGE";
                        version_compare_install
                        return;;
                [Nn]* ) return;;
                * ) echo "Please answer Y or N";;
            esac
        done
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        while true; do
            read -p "MULTIPLE XRT VERSIONS WILL EXIST ON YOUR SYSTEM. PROCEED? (Y/N)" yn
            case $yn in
                [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION};
                        yum install -y epel-release
                        version_compare_install
                        return;;
                [Nn]* ) return;;
                * ) echo "Please answer Y or N";;
            esac
        done
    elif [[ "$OSVERSION" == "centos-8" ]]; then
        while true; do
            read -p "MULTIPLE XRT VERSIONS WILL EXIST ON YOUR SYSTEM. PROCEED? (Y/N)" yn
            case $yn in
                [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION};
                        yum config-manager --set-enabled PowerTools
                        yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
                        yum config-manager --set-enabled AppStream
                        version_compare_install
                        return;;
                [Nn]* ) return;;
                * ) echo "Please answer Y or N";;
            esac
        done
    fi
}

version_compare_install() {
    CURRENT_XRT_VERSION_COMP=`$CURRENT_XRT_VERSION | tr -d .`
    XRT_VERSION_COMP=`$XRT_VERSION | tr -d .`
    if [[ "$OSVERSION" == "centos-7" || "$OSVERSION" == "centos-8" ]]; then
        if [[ "$CURRENT_XRT_VERSION_COMP" < "$XRT_VERSION_COMP" ]]; then
            yum install -y /tmp/$XRT_PACKAGE
        elif [[ "$CURRENT_XRT_VERSION_COMP" > "$XRT_VERSION_COMP" ]]; then
            yum downgrade -y /tmp/$XRT_PACKAGE
        fi
    elif [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        if [[ "$CURRENT_XRT_VERSION_COMP" < "$XRT_VERSION_COMP" ]]; then
            apt-get install -y /tmp/$XRT_PACKAGE
        elif [[ "$CURRENT_XRT_VERSION_COMP" > "$XRT_VERSION_COMP" ]]; then
            apt-get --allow-downgrades install -y /tmp/$XRT_PACKAGE
        fi
    fi
}

flash_cards() {
    if [[ "$PLATFORM" == "alveo-u50" ]]; then
        flash_cards_u50
        return
    fi
    if [[ "$PLATFORM" == "alveo-u250" ]]; then
        flash_cards_u250
        return
    fi
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Downloading Shell Package"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE
        if [[ $SHELL_PACKAGE == *.tar.gz ]]; then
            echo "Untar the package. "
            tar xzvf /tmp/$SHELL_PACKAGE -C /tmp/
            rm /tmp/$SHELL_PACKAGE
        fi
        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
            apt-get install -y /tmp/xilinx*
        elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
            yum install -y /tmp/xilinx*
        fi
        rm /tmp/xilinx*
        if [[ -f /tmp/$SHELL_PACKAGE ]]; then rm /tmp/$SHELL_PACKAGE; fi
    else
        echo "The package is already installed. "
    fi

    echo "Flash Card(s). "
    if [[ "$VERSION" == "2018.3" ]]; then
        /opt/xilinx/xrt/bin/xbutil flash -a $DSA  $TIMESTAMP
    elif [[ "$VERSION" == "2019.1" ]]; then
        /opt/xilinx/xrt/bin/xbmgmt flash -a $DSA  $TIMESTAMP
    else
        /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
    fi
}

flash_cards_u50() {
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Downloading Shell Tar File"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_TARBALL" > /tmp/$SHELL_TARBALL

        # Unpack tarball
        tar -zxvf /tmp/$SHELL_TARBALL -C /tmp
        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [["$OSVERSION" == "ubuntu-20.04"]]; then
            apt-get install -y /tmp/$CMC_PACKAGE
            apt-get install -y /tmp/$SC_PACKAGE
            apt-get install -y /tmp/$SHELL_PACKAGE
        elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
            yum install -y /tmp/$CMC_PACKAGE
            yum install -y /tmp/$SC_PACKAGE
            yum install -y /tmp/$SHELL_PACKAGE
        fi
        rm /tmp/$SHELL_PACKAGE /tmp/$CMC_PACKAGE /tmp/$SC_PACKAGE /tmp/$SHELL_TARBALL
    else
        echo "The package is already installed. "
    fi

    echo "Flash Card(s). "
    /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
}

flash_cards_u250() {
    get_packages
    check_packages
    if [[ $? != 0 ]]; then
        echo "Downloading Shell Tar File"
        wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_TARBALL" > /tmp/$SHELL_TARBALL

        # Unpack tarball
        tar -zxvf /tmp/$SHELL_TARBALL -C /tmp
        echo "Install Shell"
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [["$OSVERSION" == "ubuntu-20.04"]]; then
            apt-get install -y /tmp/$CMC_PACKAGE
            apt-get install -y /tmp/$SC_PACKAGE
            apt-get install -y /tmp/$SHELL_PACKAGE
            apt-get install -y /tmp/$VALIDATE_PACKAGE
            apt-get install -y /tmp/$2RP_SHELL_PACKAGE
        elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
            yum install -y /tmp/$CMC_PACKAGE
            yum install -y /tmp/$SC_PACKAGE
            yum install -y /tmp/$SHELL_PACKAGE
            yum install -y /tmp/$VALIDATE_PACKAGE
            yum install -y /tmp/$2RP_SHELL_PACKAGE
        fi
        rm /tmp/$SHELL_PACKAGE /tmp/$CMC_PACKAGE /tmp/$SC_PACKAGE /tmp/$SHELL_TARBALL
    else
        echo "The package is already installed. "
    fi

    echo "Flash Card(s). "
    /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
}

check_current_shell_version() {
    source /opt/xilinx/xrt/setup.sh
    xbutil scan
    if [[ $? == 0 ]]; then
        CARD_COUNT=$CARD_NO$P
        CURR_SHELL=`xbutil scan | grep xilinx | cut -d' ' -f 4 | sed -n $CARD_COUNT | cut -d'(' -f 1`
        CARD_NO=$((CARD_NO+1))
        if [[ "$CURR_SHELL" != "$DSA" ]]; then
            while true; do
                read -p "FLASH NEW SHELL? (Y/N)" yn # Prompt user with shell version
                case $yn in
                    [Yy]* ) flash_cards;
                            return;;
                    [Nn]* ) return;;
                    * ) echo "Please answer Y or N";;
                esac
            done
        else
            return
        fi
    else
        flash_cards
    fi
}

notice_disclaimer() {
    cat doc/notice_disclaimer.txt
}

detect_cards() {
    lspci > /dev/null
    if [ $? != 0 ] ; then
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
            apt-get install -y pciutils
        elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
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
CARD_NO=1
P=p

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
VERSION_ID=`grep '^VERSION_ID=' /etc/os-release | awk -F= '{print $2}'`
VERSION_ID=`echo $VERSION_ID | tr -d '"'`
OSVERSION="$OSVERSION-$VERSION_ID"

wget --help > /dev/null
if [ $? != 0 ] ; then
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [["$OSVERSION" == "ubuntu-20.04"]]; then
        apt-get install -y wget
    elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "centos-8" ]]; then
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
        check_current_shell_version
    else
        for PF in U200 U250 U280 U50; do
            if [[ "$(($PF))" != 0 ]]; then
                echo "You have $(($PF)) $PF card(s). "
                PLATFORM=`echo "alveo-$PF" | awk '{print tolower($0)}'`
                # echo $PLATFORM
                check_current_shell_version
            fi
        done
    fi
fi
