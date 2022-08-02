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
    echo "  <version>             : 2019.1 / 2019.2 / 2020.1 / 2020.2 / 2021.1 / 2021.2 / 2022.1 "
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
    echo "Support Platform                          Version      OS Version"
    echo "Alveo U280 / U50                          2019.1       CentOS 7"
    echo "Alveo U280 / U50                          2019.1       Ubuntu 16.04"
    echo "Alveo U280 / U50                          2019.1       Ubuntu 18.04"
    echo "Alveo U280 / U50                          2019.2       CentOS 7"
    echo "Alveo U280 / U50                          2019.2       Ubuntu 16.04"
    echo "Alveo U280 / U50                          2019.2       Ubuntu 18.04"
    echo "Alveo U280 / U50                          2020.1       CentOS 7"
    echo "Alveo U280 / U50                          2020.1       Ubuntu 16.04"
    echo "Alveo U280 / U50                          2020.1       Ubuntu 18.04"
    echo "Alveo U280 / U50                          2020.2       CentOS 7"
    echo "Alveo U280 / U50                          2020.2       Ubuntu 16.04"
    echo "Alveo U280 / U50                          2020.2       Ubuntu 18.04"
    echo "Alveo U280 / U50                          2021.1       CentOS 7"
    echo "Alveo U280 / U50                          2021.1       Ubuntu 16.04"
    echo "Alveo U280 / U50                          2021.1       Ubuntu 18.04"
    echo "Alveo U50                                 2021.1       Ubuntu 20.04"
    echo "Alveo U50 / U55c                          2021.2       CentOS 7"
    echo "Alveo U50 / U55c                          2021.2       Ubuntu 18.04"
    echo "Alveo U50 / U55c                          2021.2       Ubuntu 20.04"
    echo "Alveo U200 / U250 / U50 / U55c            2022.1       CentOS 7"
    echo "Alveo U200 / U250 / U50 / U55c            2022.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U50 / U55c            2022.1       Ubuntu 20.04"
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
        SHELL_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $9}' | awk -F= '{print $2}'`
        if [[ "$PLATFORM" == "alveo-u250" ]]; then
            FLASH_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $14}' | awk -F= '{print $2}'`
            SHELL_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $11}' | awk -F= '{print $2}'`
            SHELL_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $15}' | awk -F= '{print $2}'`
        fi
    else
        echo "ERROR: Your combination of OS/Cards/XRT Version is not supported. Please reference the list below for supported combinations."    
        list
        exit 1
    fi
}

install_xrt() {
    if [[ "$LOCAL_XRT" != "NONE" ]]; then
        echo "STATUS: Installing XRT locally from $LOCAL_XRT."
        XRT_LOC=$LOCAL_XRT
        XRT_VERSION=`echo $LOCAL_XRT | rev | cut -d'/' -f 1 | rev | cut -d'_' -f 2`
    else
        echo "STATUS: Downloading XRT ($XRT_VERSION) installation package."
        wget -q -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$XRT_PACKAGE" > /tmp/$XRT_PACKAGE
        XRT_LOC=`echo /tmp/$XRT_PACKAGE`
    fi    

    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        dpkg -s xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`dpkg -s xrt | grep Version | cut -d' ' -f 2`
            if [[ "$CURRENT_XRT_VERSION" != "$XRT_VERSION" ]]; then
                while true; do
                    read -p "CHECK: Current XRT host version: $CURRENT_XRT_VERSION. remove this version? [Y/N]" yn # Prompt user with which version will be removed
                    case $yn in
                        [Yy]* ) remove_xrt; break;;
                        [Nn]* ) multiple_xrt; break;;
                        * ) echo "INFO: Please answer Y or N.";;
                    esac
                done
            else
                echo "INFO: You already have this version of XRT ($XRT_VERSION) installed."
                return
            fi
        else
            echo "INFO: No XRT version detected on this machine. Installing $XRT_PACKAGE."
            apt update
            apt install -y python3-pip
            pip3 install --upgrade pip
            pip3 install pyopencl==2020.1
            apt-get install -y --reinstall $XRT_LOC
        fi
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        rpm -q xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`rpm -q xrt | cut -d'-' -f 2`
            if [[ "$CURRENT_XRT_VERSION" != "$XRT_VERSION" ]]; then
                while true; do
                    read -p "CHECK: Current XRT host version: $CURRENT_XRT_VERSION. remove this version? [Y/N]" yn # Prompt user with which version will be removed
                    case $yn in
                        [Yy]* ) remove_xrt; break;;
                        [Nn]* ) multiple_xrt; break;;
                        * ) echo "INFO: Please answer Y or N.";;
                    esac
                done
            else
                echo "INFO: You already have this version of XRT ($XRT_VERSION) installed."
                return
            fi
        else
            if [[ "$OSVERSION" == "centos-7" ]] ; then
                yum install -y epel-release
                yum install -y $XRT_LOC
            fi
        fi
    fi
    rm $XRT_LOC
}

check_packages() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        PACKAGE_INSTALL_INFO=`apt list --installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        PACKAGE_INSTALL_INFO=`yum list installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    fi
}

remove_xrt() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        while true; do
            read -p "CHECK: Remove XRT with dependencies? [Y/N]" yn
            case $yn in
                [Yy]* ) dpkg -r xrt; break;;
                [Nn]* ) dpkg -r --force-depends xrt; break;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
        apt-get install -y $XRT_LOC
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        while true; do
            read -p "CHECK: Remove XRT with dependencies? [Y/N]" yn
            case $yn in
                [Yy]* ) yum remove xrt; break;;
                [Nn]* ) rpm -e --nodeps xrt; break;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
        yum install -y $XRT_LOC
    fi
}

multiple_xrt() {
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        while true; do
            read -p "CHECK: Multiple XRT versions will exist on your system. Proceed? [Y/N]" yn
            case $yn in
                [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION}; # Add what will be the result if they choose yes
                        apt update; # Old XRT version has been renamed, new XRT version is now default
                        apt install -y python3-pip;
                        pip3 install --upgrade pip;
                        pip3 install pyopencl==2020.1;
                        echo "STATUS: Installing XRT Version: $XRT_PACKAGE.";
                        version_compare_install
                        return;;
                [Nn]* ) return;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
    elif [[ "$OSVERSION" == "centos-7" ]]; then
        while true; do
            read -p "CHECK: Multiple XRT versions will exist on your system. Proceed? [Y/N]" yn
            case $yn in
                [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION};
                        yum install -y epel-release
                        version_compare_install
                        return;;
                [Nn]* ) return;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
    fi
}

version_compare_install() {
    CURRENT_XRT_VERSION_COMP=`$CURRENT_XRT_VERSION | tr -d .`
    XRT_VERSION_COMP=`$XRT_VERSION | tr -d .`
    if [[ "$OSVERSION" == "centos-7" ]]; then
        if [[ "$CURRENT_XRT_VERSION_COMP" < "$XRT_VERSION_COMP" ]]; then
            yum install -y $XRT_LOC
        elif [[ "$CURRENT_XRT_VERSION_COMP" > "$XRT_VERSION_COMP" ]]; then
            yum downgrade -y $XRT_LOC
        fi
    elif [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        if [[ "$CURRENT_XRT_VERSION_COMP" < "$XRT_VERSION_COMP" ]]; then
            apt-get install -y $XRT_LOC
        elif [[ "$CURRENT_XRT_VERSION_COMP" > "$XRT_VERSION_COMP" ]]; then
            apt-get --allow-downgrades install -y $XRT_LOC
        fi
    fi
}

flash_cards() {
    check_packages
    if [[ $? != 0 ]]; then
        echo "STATUS: Downloading Shell Package(s)."
        wget -q -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE
        if [[ $SHELL_PACKAGE == *.tar.gz ]]; then
            echo "STATUS: Untarring the package."
            tar xzvf /tmp/$SHELL_PACKAGE -C /tmp/
            rm /tmp/$SHELL_PACKAGE
        fi
        echo "STATUS: Installing Shell Package(s)."
        if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
            apt-get install -y /tmp/xilinx*
        elif [[ "$OSVERSION" == "centos-7" ]]; then
            yum install -y /tmp/xilinx*
        fi
        rm /tmp/xilinx*
        if [[ -f /tmp/$SHELL_PACKAGE ]]; then rm /tmp/$SHELL_PACKAGE; fi
    else
        echo "INFO: The package is already installed."
    fi

    echo "STATUS: Flashing Card(s). "
    if [[ "$PLATFORM" == "alveo-u250" ]]; then
        echo "STATUS: Flashing ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}."
        /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --base
        echo "INFO: The system requires a cold reboot before the next step of the 2RP shell process can begin."
        echo "INFO: After the cold reboot, please run /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --shell $FLASH_PACKAGE to finish the 2RP shell flash."
    else
        if [[ "$VERSION" == "2019.1" ]]; then
            /opt/xilinx/xrt/bin/xbmgmt flash -a $DSA  $TIMESTAMP
        elif [[ "$VERSION" == "2019.2" ]] || [[ "$VERSION" == "2020.1" ]] || [[ "$VERSION" == "2020.2" ]] || [[ "$VERSION" == "2021.1" ]] || [[ "$VERSION" == "2021.2" ]]; then 
            /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA
        else
            echo "STATUS: Flashing ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}."
            /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --base
        fi
    fi
}

check_current_shell_version() {
    get_packages
    source /opt/xilinx/xrt/setup.sh > /dev/null
    xbutil examine >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        CURR_SHELL=`xbmgmt examine --device ${cardLocArr[$cardIndex]} | grep Platform | cut -d':' -f 2 | sed -n 1p | sed -e 's/^[[:space:]]*//'`
        echo "INFO: Current shell on ${cardLocArr[$cardIndex]} is $CURR_SHELL."
        echo "INFO: New shell to be installed on ${cardLocArr[$cardIndex]} is $SHELL_NAME."
        if [[ "$CURR_SHELL" != "$SHELL_NAME" ]]; then
            while true; do
                read -p "CHECK: Flash new shell version? [Y/N]" yn # Prompt user with shell version
                case $yn in
                    [Yy]* ) flash_cards;
                            return;;
                    [Nn]* ) return;;
                    * ) echo "INFO: Please answer Y or N.";;
                esac
            done
        else
            echo "INFO: $SHELL_NAME already exists on ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}. Skipping"
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
        elif [[ "$OSVERSION" == "centos-7" ]]; then
            yum install -y pciutils
        fi
    fi

    for DEVICE_ID in $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f7); do
        if [[ "$DEVICE_ID" == "5000" ]] || [[ "$DEVICE_ID" == "d000" ]]; then
            U200=$((U200 + 1))
            cardTypeArr+=("alveo-u200")
        elif [[ "$DEVICE_ID" == "5004" ]] || [[ "$DEVICE_ID" == "d004" ]]; then
            U250=$((U250 + 1))
            cardTypeArr+=("alveo-u250")
        elif [[ "$DEVICE_ID" == "5008" ]] || [[ "$DEVICE_ID" == "d008" ]] || [[ "$DEVICE_ID" == "500c" ]] || [[ "$DEVICE_ID" == "d00c" ]]; then
            U280=$((U280 + 1))
            cardTypeArr+=("alveo-u280")
        elif [[ "$DEVICE_ID" == "5020" ]] || [[ "$DEVICE_ID" == "d020" ]]; then
            U50=$((U50 + 1))
            cardTypeArr+=("alveo-u50")
        elif [[ "$DEVICE_ID" == "505c" ]]; then
            U55c=$((U55c + 1))
            cardTypeArr+=("alveo-u55c")
        fi
    done
    for cardLoc in  $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f1); do
        cardLocArr+=("0000:$cardLoc")
    done
}

display_cards() {
    i=0
    for cardInfo in ${cardTypeArr[@]}; do 
        echo "${cardTypeArr[$i]} detected at ${cardLocArr[$i]}"
        i=$((i + 1))
    done
}

confirm() {
    read -r -p "${1:-CHECK: Do you want to proceed? [y/n]:} " response
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
   echo "ERROR: This script must be run as root."
   exit 1
fi

XRT=1
SHELL=1
cardLocArr=()
cardTypeArr=()
cardIndex=0
PLATFORM="alveo-u200"
VERSION="NONE"
PLATFORM_ONLY="NONE"
LOCAL_XRT="NONE"
INSTALL_DOCKER=0
U200=0
U250=0
U280=0
U50=0
U55c=0

notice_disclaimer
confirm

while true
do
case "$1" in
    --skip-xrt-install   ) XRT=0             ; shift 1 ;;
    --skip-shell-flash   ) SHELL=0           ; shift 1 ;;
    -v|--version         ) VERSION="$2"      ; shift 2 ;;
    --local-xrt          ) LOCAL_XRT="$2"    ; shift 2 ;;
    -p|--platform        ) PLATFORM_ONLY="$2"; shift 2 ;;
    --install-docker     ) INSTALL_DOCKER=1  ; shift 1 ;;
    -h|--help            ) usage             ; exit  1 ;;
    --combinations       ) list              ; exit  1 ;;
    ""                   ) break ;;
*) echo "ERROR: Invalid option: $1."; usage; exit 1 ;;
esac
done

if [ $? != 0 ] ; then echo "ERROR: Failed parsing options." >&2 ; usage; exit 1 ; fi

OSVERSION=`grep '^ID=' /etc/os-release | awk -F= '{print $2}'`
OSVERSION=`echo $OSVERSION | tr -d '"'`
VERSION_ID=`grep '^VERSION_ID=' /etc/os-release | awk -F= '{print $2}'`
VERSION_ID=`echo $VERSION_ID | tr -d '"'`
OSVERSION="$OSVERSION-$VERSION_ID"

wget --help > /dev/null
if [ $? != 0 ] ; then
    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]]; then
        apt-get install -y wget
    elif [[ "$OSVERSION" == "centos-7" ]]; then
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

if [[ "$XRT" == 0 &&  "$SHELL" == 0 ]] ; then echo "ERROR: Please do NOT skip both XRT installation and card flashing." >&2 ; usage; exit 1 ; fi

detect_cards

if [[ "$XRT" == 1 ]]; then
    echo "STATUS: Installing XRT."
    if [[ "$LOCAL_XRT" == "NONE" ]]; then
        get_packages
    fi
    install_xrt
fi

if [[ "$SHELL" == 1 ]]; then
    echo "STATUS: Detected cards: "
    display_cards
    echo "STATUS: Installing Shell."
    if [[ "$PLATFORM_ONLY" != "NONE" ]]; then
        PF=`echo $PLATFORM_ONLY | awk -F'-' '{print $2}' | awk '{print toupper($0)}'`
        if [[ "$(($PF))" == 0 ]]; then
            echo "ERROR: You don't have any $PF card(s). "
            exit 1
        fi
        for cardType in ${cardTypeArr[@]}; do 
            PLATFORM=`echo "$cardType"`
            if [[ "$PLATFORM_ONLY" != "$cardType" ]]; then
                echo "INFO: Looking for $PLATFORM_ONLY card, found $PLATFORM card at ${cardLocArr[$cardIndex]}. Skipping."
                cardIndex=$((cardIndex+1))
                continue;
            else 
                echo "INFO: Found $PLATFORM card at ${cardLocArr[$cardIndex]}."
                check_current_shell_version
                cardIndex=$((cardIndex+1))
            fi
        done
    else    
        for cardType in ${cardTypeArr[@]}; do 
            PLATFORM=`echo "$cardType"`
            check_current_shell_version
            cardIndex=$((cardIndex+1))
        done
    fi
fi
