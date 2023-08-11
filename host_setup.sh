#!/usr/bin/env bash
#
# (C) Copyright 2022, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
    echo "Running host_setup.sh to install XRT and flash Shell on host machine. "
    echo ""
    echo "Usage:"
    echo "  ./host_setup.sh --version <version>"
    echo "  ./host_setup.sh  -v       <version>"
    echo "  <version>             : 2019.1 / 2019.2 / 2020.1 / 2020.2 / 2021.1 / 2021.2 / 2022.1 / 2022.2 "
    echo "  --skip-xrt-install    : skip install XRT"
    echo "  --skip-shell-flash    : skip flash Shell"
    echo "  --install-docker      : install docker service"
    echo "  --install-local-xrt   : install local version of XRT (provide hard path)"
    echo "  -p | --platform:      : flash only cards of the specified card platform"
    echo "  --combinations        : list avialable card OS/Card combinations"
    echo ""
    echo "Example:"
    echo "Install 2019.2 XRT and flash Shell on alveo-u200 card"
    echo "  ./host_setup.sh -v 2019.2 -p alveo-u200"

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
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.1       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.1       Ubuntu 20.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.2       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.2       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.2       Ubuntu 20.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2022.2       Ubuntu 22.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2023.1       CentOS 7"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2023.1       Ubuntu 18.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2023.1       Ubuntu 20.04"
    echo "Alveo U200 / U250 / U280 / U50 / U55c     2023.1       Ubuntu 22.04"
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
    COMB=`echo $COMB| tr '[:upper:]' '[:lower:]'`
    echo "INFO: Configuration is $COMB"
    if grep -q $COMB "conf/spec.txt"; then
        XRT_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $1}' | awk -F= '{print $2}'`
        SHELL_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $2}' | awk -F= '{print $2}'`
        DSA=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $3}' | awk -F= '{print $2}'`
        TIMESTAMP=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $4}' | awk -F= '{print $2}'`
        PACKAGE_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $6}' | awk -F= '{print $2}'`
        PACKAGE_VERSION=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $7}' | awk -F= '{print $2}'`
        XRT_VERSION=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $8}' | awk -F= '{print $2}'`
        if [[ "$PLATFORM" == "alveo-u250" ]]; then
            FLASH_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $14}' | awk -F= '{print $2}'`
            SHELL_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $11}' | awk -F= '{print $2}'`
            SHELL_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $15}' | awk -F= '{print $2}'`
            TRP_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $16}' | awk -F= '{print $2}'`
	    XRM_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $17}' | awk -F= '{print $2}'`
        else
            SHELL_NAME=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $9}' | awk -F= '{print $2}'`
	    XRM_PACKAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $10}' | awk -F= '{print $2}'`
        fi
	echo "INFO: Shell package to be flashed is $SHELL_NAME"
    else
        echo "ERROR: Your combination of OS/Cards/XRT versions($COMB) is not supported. Please reference the list below for supported combinations." 
        SKIP_SHELL_FLASH=1   
        list
    fi
}

get_packages_xrt() {
    COMB="${VERSION}_${OSVERSION}"
    echo "INFO: Configuration is $COMB"
    if grep -q $COMB "conf/spec_xrt.txt"; then
        XRT_PACKAGE=`grep ^$COMB: conf/spec_xrt.txt | awk -F':' '{print $2}' | awk -F';' '{print $1}' | awk -F= '{print $2}'`
        XRT_VERSION=`grep ^$COMB: conf/spec_xrt.txt | awk -F':' '{print $2}' | awk -F';' '{print $2}' | awk -F= '{print $2}'`
    else
        echo "ERROR: Your combination of OS/XRT Version is not supported. Please reference the list below for supported combinations."    
        list
	exit
    fi
}

card_setup() {
    for DEVICE_ID in $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f7); do
        if [[ "$DEVICE_ID" == "5000" ]] || [[ "$DEVICE_ID" == "d000" ]] || [[ "$DEVICE_ID" == "5010" ]]; then
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
        elif [[ "$DEVICE_ID" == "513c" ]]; then
            U30=$((U30 + 1))
            cardTypeArr+=("alveo-u30")
        fi
    done
    for cardLoc in  $(lspci  -d 10ee: | grep " Processing accelerators" | grep "Xilinx" | grep ".0 " | cut -d" " -f1); do
        cardLocArr+=("0000:$cardLoc")
    done
    
    i=0
    for cardInfo in ${cardTypeArr[@]}; do 
        echo "${cardTypeArr[$i]} detected at ${cardLocArr[$i]}"
        i=$((i + 1))
    done
}

detect_xrt() {
    if [[ "$UBUNTU" == 1 ]]; then
        dpkg -s xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`dpkg -s xrt | grep Version | cut -d' ' -f 2`
            echo "INFO: Current XRT installation found is $CURRENT_XRT_VERSION"
        else
            CURRENT_XRT_VERSION="NONE"
            echo "INFO: No XRT installation was found."
        fi
    elif [[ "$CENTOS" == 1 ]]; then
        rpm -q xrt > /dev/null 2>&1
        if [[ $? == 0 ]]; then
            CURRENT_XRT_VERSION=`rpm -q xrt | cut -d'-' -f 2`
            echo "INFO: Current XRT installation found is $CURRENT_XRT_VERSION"
        else
            CURRENT_XRT_VERSION="NONE"
            echo "INFO: No XRT installation was found."
        fi
    fi
}

check_packages() {
    if [[ "$UBUNTU" == 1 ]]; then
        PACKAGE_INSTALL_INFO=`apt list --installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    elif [[ "$CENTOS" == 1 ]]; then
        PACKAGE_INSTALL_INFO=`yum list installed 2>/dev/null | grep "$PACKAGE_NAME" | grep "$PACKAGE_VERSION"`
    fi
}

os_setup() {
    OSVERSION=`grep '^ID=' /etc/os-release | awk -F= '{print $2}'`
    OSVERSION=`echo $OSVERSION | tr -d '"'`
    VERSION_ID=`grep '^VERSION_ID=' /etc/os-release | awk -F= '{print $2}'`
    VERSION_ID=`echo $VERSION_ID | tr -d '"'`
    OSVERSION="$OSVERSION-$VERSION_ID"
    OS=`cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f 2`
    echo "Detected Operating System: $OS"

    if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]] || [[ "$OSVERSION" == "ubuntu-20.04" ]] || [[ "$OSVERSION" == "ubuntu-22.04" ]]; then
        UBUNTU=1
    elif [[ "$OSVERSION" == "centos-7" ]] || [[ "$OSVERSION" == "rhel-7.8" ]]; then
        CENTOS=1
    else
        echo "ERROR: Unsupported OS detected. Exiting."
        exit 1
    fi
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

init() {
    XRT=1
    SHELL=1
    XRM=1
    UBUNTU=0
    CENTOS=0
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
    U30=0
    YES=0
    WIZARD=0
}

setup() {
    os_setup
    lspci > /dev/null
    if [ $? != 0 ] ; then
        if [[ "$UBUNTU" == 1 ]]; then
            apt-get -qq install -y pciutils
        elif [[ "$CENTOS" == 1 ]]; then
            yum install -q -y pciutils
        fi
    fi

    wget --help > /dev/null
    if [ $? != 0 ] ; then
        if [[ "$UBUNTU" == 1 ]]; then
            apt-get -qq install -y wget
        elif [[ "$CENTOS" == 1 ]]; then
            yum install -q -y wget
        fi
    fi

    if [[ "$UBUNTU" == 1 ]]; then
        ls /usr/src/linux-headers-$(uname -r) > /dev/null
        if [ $? != 0 ] ; then
            apt-get -qq install -y linux-headers-$(uname -r)
        fi
    elif [[ "$CENTOS" == 1 ]]; then
        ls /usr/src/kernels/$(uname -r) > /dev/null
        if [ $? != 0 ] ; then
            yum install -q -y kernel-devel-$(uname -r)
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
    card_setup
}

multiple_xrt() {
    while true; do
        read -p "CHECK: Multiple XRT versions will exist on your system. Proceed? [Y/N]: " yn
        case $yn in
            [Yy]* ) mv /opt/xilinx/xrt/ /opt/xilinx/xrt_${CURRENT_XRT_VERSION} # Add what will be the result if they choose yes
                    if [[ "$UBUNTU" == 1 ]]; then
                        apt update; # Old XRT version has been renamed, new XRT version is now default
                        apt install -y python3-pip
                        pip3 install --upgrade pip
                        pip3 install pyopencl==2020.1
                    elif [[ "$CENTOS" == 1 ]]; then
                        yum install -q -y epel-release
                    fi
                    echo "STATUS: Installing XRT Version: $XRT_PACKAGE."
                    version_compare_install
                    return;;
            [Nn]* ) return;;
            * ) echo "INFO: Please answer Y or N.";;
        esac
    done
}

remove_xrt() {
    if [[ "$YES" == 1 ]]; then
        if [[ "$UBUNTU" == 1 ]]; then dpkg -r xrt
        elif [[ "$CENTOS" == 1 ]]; then yum -q remove xrt; fi
    else
        while true; do
            read -p "CHECK: Remove XRT with dependencies? [Y/N]: " yn
            case $yn in
                [Yy]* ) if [[ "$UBUNTU" == 1 ]]; then dpkg -r xrt
                        elif [[ "$CENTOS" == 1 ]]; then yum -q remove xrt; fi
                        break;;
                [Nn]* ) if [[ "$UBUNTU" == 1 ]]; then dpkg -r --force-depends xrt
                        elif [[ "$CENTOS" == 1 ]]; then rpm -e --nodeps xrt; fi
                        break;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
    fi

    if [[ "$UBUNTU" == 1 ]]; then
        apt-get -qq install -y $XRT_LOC
    elif [[ "$CENTOS" == 1 ]]; then 
        yum install -q -y $XRT_LOC
    fi
}

version_compare_install() {
    CURRENT_XRT_VERSION_COMP=`$CURRENT_XRT_VERSION | tr -d .`
    XRT_VERSION_COMP=`$XRT_VERSION | tr -d .`
    if [[ "$CURRENT_XRT_VERSION_COMP" < "$XRT_VERSION_COMP" ]]; then
        if [[ "$UBUNTU" == 1 ]]; then apt-get -qq install -y $XRT_LOC
        elif [[ "$CENTOS" == 1 ]]; then yum install -q -y $XRT_LOC; fi
    elif [[ "$CURRENT_XRT_VERSION_COMP" > "$XRT_VERSION_COMP" ]]; then
        if [[ "$UBUNTU" == 1 ]]; then apt-get --allow-downgrades install -y $XRT_LOC
        elif [[ "$CENTOS" == 1 ]]; then yum downgrade -q -y $XRT_LOC; fi
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
        if [[ "$OSVERSION" == "ubuntu-16.04" || "$OSVERSION" == "ubuntu-18.04" || "$OSVERSION" == "ubuntu-20.04" || "$OSVERSION" == "ubuntu-22.04" ]]; then
            apt-get -qq install -y /tmp/xilinx*
        elif [[ "$OSVERSION" == "centos-7" ]]; then
            yum install -q -y /tmp/xilinx*
        fi
        rm /tmp/xilinx*
        if [[ -f /tmp/$SHELL_PACKAGE ]]; then rm /tmp/$SHELL_PACKAGE; fi
    else
        echo "INFO: The package is already installed."
    fi

    echo "STATUS: Flashing Card(s). "
    if [[ "$PLATFORM" == "alveo-u250" ]]; then
        echo "STATUS: Flashing ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}."
        /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --base --force
        echo "INFO: The system requires a cold reboot before the next step of the 2RP shell process can begin."
        echo "INFO: After the cold reboot, please run /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --shell $FLASH_PACKAGE to finish the 2RP shell flash."
    else
        if [[ "$VERSION" == "2019.1" ]]; then
            /opt/xilinx/xrt/bin/xbmgmt flash -a $DSA  $TIMESTAMP --force
        elif [[ "$VERSION" == "2019.2" ]] || [[ "$VERSION" == "2020.1" ]] || [[ "$VERSION" == "2020.2" ]] || [[ "$VERSION" == "2021.1" ]] || [[ "$VERSION" == "2021.2" ]]; then 
            /opt/xilinx/xrt/bin/xbmgmt flash --update --shell $DSA --force
        else 
            echo "STATUS: Flashing ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}."
            /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --base --force
        fi
    fi
}

check_current_shell_version() {
    get_packages
    if [[ "$SKIP_SHELL_FLASH" == 1 ]]; then
        SKIP_SHELL_FLASH=0
        return
    fi
    source /opt/xilinx/xrt/setup.sh > /dev/null
    xbutil examine >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        CURR_SHELL=`xbmgmt examine --device ${cardLocArr[$cardIndex]} | grep Platform | cut -d':' -f 2 | sed -n 1p | sed -e 's/^[[:space:]]*//'`
        if [[ "$PLATFORM" == "alveo-u250" && "$CURR_SHELL" == "$SHELL_NAME" && "$YES" == 1 ]]; then
            echo "STATUS: Base Layer of U250 shell detected, automatically flashing 2RP Layer."
            ls $FLASH_PACKAGE > /dev/null
            if [[ $? != 0 ]]; then
                echo "STATUS: 2RP Package not detected on system, downloading from web"
                wget -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$SHELL_PACKAGE" > /tmp/$SHELL_PACKAGE
                tar xzvf /tmp/$SHELL_PACKAGE -C /tmp/
                rm /tmp/$SHELL_PACKAGE
                if [[ "$UBUNTU" == 1 ]]; then
                    apt-get -qq install -y /tmp/xilinx*
                elif [[ "$CENTOS" == 1 ]]; then
                    yum install -q -y /tmp/xilinx*
                fi
                rm /tmp/xilinx*
            fi
            /opt/xilinx/xrt/bin/xbmgmt program --device ${cardLocArr[$cardIndex]} --shell $FLASH_PACKAGE
            return
        fi
        if [[ "$PLATFORM" == "alveo-u250" && "$CURR_SHELL" == "$TRP_NAME" ]]; then
            echo "INFO: 2RP Layer of U250 shell detected, skipping."
            return
        fi
        echo "INFO: Current shell on ${cardLocArr[$cardIndex]} is $CURR_SHELL."
        echo "INFO: New shell to be installed on ${cardLocArr[$cardIndex]} is $SHELL_NAME."
        if [[ "$CURR_SHELL" != "$SHELL_NAME" ]]; then
            if [[ "$YES" == 1 ]]; then
                flash_cards
            else
                while true; do
                    read -p "CHECK: Flash new shell version? [Y/N]: " yn # Prompt user with shell version
                    case $yn in
                        [Yy]* ) flash_cards; return;;
                        [Nn]* ) return;;
                        * ) echo "INFO: Please answer Y or N.";;
                    esac
                done
            fi
        else
            echo "INFO: $SHELL_NAME already exists on ${cardTypeArr[$cardIndex]} card at ${cardLocArr[$cardIndex]}. Skipping"
            return
        fi
    else
        flash_cards
    fi
}

install_xrt() {
    # Wizard Options
    if [[ "$LOCAL_XRT_OPTION" == 1 ]]; then
        read -p "CHECK: Please provide the hard path to the local XRT package: " yn
        XRT_LOC=$yn
        XRT_VERSION=`echo $LOCAL_XRT | rev | cut -d'/' -f 1 | rev | cut -d'_' -f 2`
    elif [[ "$MAJOR_XRT_OPTION" == 1 ]]; then
        echo "CHECK: Please select one of the following XRT Major Versions"
        echo "OPTION 1: 2019.1"
        echo "OPTION 2: 2019.2"
        echo "OPTION 3: 2020.1"
        echo "OPTION 4: 2020.2"
        echo "OPTION 5: 2021.1"
        echo "OPTION 6: 2021.2"
        echo "OPTION 7: 2022.1"
        echo "OPTION 8: 2022.2"
        echo "OPTION 9: 2023.1"
        while true; do
            read -p "CHECK: Please enter your choice from the options above [1-9]: " yn
            case $yn in
                [1]* ) VERSION=2019.1; break ;;
                [2]* ) VERSION=2019.2; break ;;
                [3]* ) VERSION=2020.1; break ;;
                [4]* ) VERSION=2020.2; break ;;
                [5]* ) VERSION=2021.1; break ;;
                [6]* ) VERSION=2021.2; break ;;
                [7]* ) VERSION=2022.1; break ;;
                [8]* ) VERSION=2022.2; break ;;
                [9]* ) VERSION=2023.1; break ;;
                * ) echo "INFO: Please answer 1, 2, 3, 4, 5, 6, 7, 8, or 9";;
            esac
        done
        get_packages_xrt
    elif [[ "$SKIP_XRT_OPTION" == 1 ]]; then
        return
    fi
    
    # Original Flow Options
    if [[ "$LOCAL_XRT" != "NONE" ]]; then
        echo "STATUS: Installing XRT locally from $LOCAL_XRT."
        XRT_LOC=$LOCAL_XRT
        XRT_VERSION=`echo $LOCAL_XRT | rev | cut -d'/' -f 1 | rev | cut -d'_' -f 2`
    else
        echo "STATUS: Downloading XRT ($XRT_VERSION) installation package."
        wget -q -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$XRT_PACKAGE" > /tmp/$XRT_PACKAGE
        XRT_LOC=`echo /tmp/$XRT_PACKAGE`
    fi    

    # XRT Installation
    if [[ "$CURRENT_XRT_VERSION" == "NONE" ]]; then
        echo "INFO: No XRT version detected on this machine. Installing $XRT_PACKAGE."
        if [[ "$UBUNTU" == 1 ]]; then
            apt-get -qq update -y
            apt-get -qq install -y python3-pip
            pip3 install --upgrade pip 
            pip3 install pyopencl==2020.1
            apt-get -qq install -y --reinstall $XRT_LOC      
        elif [[ "$CENTOS" == 1 ]]; then
            yum install -q -y epel-release
            yum install -q -y $XRT_LOC
        fi
    elif [[ "$CURRENT_XRT_VERSION" != "$XRT_VERSION" ]]; then
        if [[ "$YES" == 1 ]]; then
            remove_xrt
        else
            while true; do
                read -p "CHECK: Current XRT host version: $CURRENT_XRT_VERSION. remove this version? [Y/N]: " yn # Prompt user with which version will be removed
                case $yn in
                    [Yy]* ) remove_xrt
                            break;;
                    [Nn]* ) multiple_xrt
                            break;;
                    * ) echo "INFO: Please answer Y or N.";;
                esac
            done
        fi
    else
        echo "INFO: You already have this version of XRT ($XRT_VERSION) installed."
        return
    fi
    rm $XRT_LOC
}

shell_flash() {
    if [[ "$MAJOR_SHELL_OPTION" == 1 && "$MAJOR_XRT_OPTION" == 1 ]]; then
        echo "STATUS: Flashing cards with $VERSION shell."
    elif [[ "$MAJOR_SHELL_OPTION" == 1 && "$MAJOR_XRT_OPTION" == 0 ]]; then
        echo "CHECK: Please select one of the following Shell Major Versions"
        echo "OPTION 1: 2019.1"
        echo "OPTION 2: 2019.2"
        echo "OPTION 3: 2020.1"
        echo "OPTION 4: 2020.2"
        echo "OPTION 5: 2021.1"
        echo "OPTION 6: 2021.2"
        echo "OPTION 7: 2022.1"
        echo "OPTION 8: 2022.2"
        echo "OPTION 9: 2023.1"
        while true; do
            read -p "CHECK: Please enter your choice from the options above [1-9]: " yn
            case $yn in
                [1]* ) VERSION=2019.1; break ;;
                [2]* ) VERSION=2019.2; break ;;
                [3]* ) VERSION=2020.1; break ;;
                [4]* ) VERSION=2020.2; break ;;
                [5]* ) VERSION=2021.1; break ;;
                [6]* ) VERSION=2021.2; break ;;
                [7]* ) VERSION=2022.1; break ;;
                [8]* ) VERSION=2022.2; break ;;
                [9]* ) VERSION=2023.1; break ;;
                * ) echo "INFO: Please answer 1, 2, 3, 4, 5, 6, 7, 8, or 9";;
            esac
        done
    elif [[ "$PLATFORM_SHELL_OPTION" == 1 ]]; then
        VERSION=2022.2
        echo "CHECK: Please select one of the following card types"
        echo "OPTION 1: U50"
        echo "OPTION 2: U200"
        echo "OPTION 3: U250"
        echo "OPTION 4: U55c"
        while true; do
            read -p "CHECK: Please enter your choice from the options above [1-4]: " yn
            case $yn in
                [1]* ) PLATFORM_ONLY=alveo-u50; break ;;
                [2]* ) PLATFORM_ONLY=alveo-u200; break ;;
                [3]* ) PLATFORM_ONLY=alveo-u250; break ;;
                [4]* ) PLATFORM_ONLY=alveo-u55c; break ;;
                * ) echo "INFO: Please answer 1, 2, 3, or 4";;
            esac
        done
    fi
    
    if [[ "$PLATFORM_ONLY" != "NONE" ]]; then
        PF=`echo $PLATFORM_ONLY | tr '[:lower:]' '[:upper:]'`
        PLATFORM_ONLY=`echo $PLATFORM_ONLY | tr '[:upper:]' '[:lower:]'`
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
}

check_xrm() {
    if [[ "$YES" == 1 ]]; then
        install_xrm
    else 
        while true; do
            read -p "CHECK: Do you want to install XRM? [y/n]: " yn
            case $yn in
                [Yy]* ) install_xrm;
                        break;;
                [Nn]* ) echo ""
                        break;;
                * ) echo "INFO: Please answer Y or N.";;
            esac
        done
    fi
}

install_xrm() {
    wget -q -cO - "https://www.xilinx.com/bin/public/openDownload?filename=$XRM_PACKAGE" > /tmp/$XRM_PACKAGE
        if [[ "$UBUNTU" == 1 ]]; then
            apt-get install -y -qq /tmp/$XRM_PACKAGE
        elif [[ "$CENTOS" == 1 ]]; then
            yum install -y -qq /tmp/$XRM_PACKAGE
        fi
}

default() {
    if [[ "$XRT" == 1 ]]; then
        echo "STATUS: Installing XRT."
        if [[ "$LOCAL_XRT" == "NONE" ]]; then
       	    get_packages
        else
	    get_packages_xrt
	fi
        install_xrt
    fi
    if [[ "$SHELL" == 1 ]]; then
        echo "STATUS: Installing Shell."
        shell_flash
    fi
    if [[ "$XRM" == 1 ]]; then
        echo "STATUS: Installing XRM."
        check_xrm
    fi
    echo "STATUS: host_setup complete."
}

wizard() {
    # step 1, XRT check
    echo "CHECK: Please select one of the following in regards to XRT installation."
    echo "OPTION 1: Install Local XRT"
    echo "OPTION 2: Install Major XRT Version (2019.1-2023.1)"
    echo "OPTION 3: Skip XRT Installation"
    while true; do
        read -p "CHECK: Please enter your choice from the options above [1-3]: " yn
        case $yn in
            [1]* ) LOCAL_XRT_OPTION=1; break ;;
            [2]* ) MAJOR_XRT_OPTION=1; break ;;
            [3]* ) SKIP_XRT_OPTION=1; MAJOR_XRT_OPTION=0; break ;;
            * ) echo "INFO: Please answer 1, 2, or 3";;
        esac
    done
    install_xrt

    if [ ${#cardLocArr[@]} -eq 0 ]; then
        echo "INFO: No cards detected, skipping shell flash."
        echo "STATUS: host_setup wizard complete."
        exit;
    fi

    # step 2, Shell flash
    if [[ "$LOCAL_XRT_OPTION" == 1 ]]; then
        return
    elif [[ "$MAJOR_XRT_OPTION" == 1 ]]; then
        echo "CHECK: Please select one of the following in regards to card shell flash."
        echo "OPTION 1: Flash cards with $VERSION shell."
        echo "OPTION 2: Skip Shell Flash."
        while true; do
            read -p "CHECK: Please enter your choice from the options above [1-2]: " yn
            case $yn in
                [1]* ) MAJOR_SHELL_OPTION=1; break ;;
                [2]* ) return;;
                * ) echo "INFO: Please answer 1 or 2.";;
            esac
        done
    elif [[ "$SKIP_XRT_OPTION" == 1 ]]; then
        echo "CHECK: Please select one of the following in regards to card shell flash."
        echo "OPTION 1: Flash Major Shell Version (2019.1-2023.1)."
        echo "OPTION 2: Flash Card Platform ( U50 / U200 / U250 / U55c ) with latest Shell Version."
        while true; do
            read -p "CHECK: Please enter your choice from the options above [1-2]: " yn
            case $yn in
                [1]* ) MAJOR_SHELL_OPTION=1; break ;;
                [2]* ) PLATFORM_SHELL_OPTION=1; break ;;
                * ) echo "INFO: Please answer 1 or 2.";;
            esac
        done
    fi
    shell_flash
    echo "STATUS: host_setup wizard complete."
}

main() {
    setup
    detect_xrt
    if [[ "$WIZARD" == 0 ]]; then
        default    
    else
        wizard
    fi
}

# Start Flow
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root."
   exit 1
fi

init

if [ "$*" == "" ]; then
    WIZARD=1
else
    while true
    do
        case "$1" in
            -v|--version         ) VERSION="$2"      ; shift 2 ;;
            --install-local-xrt  ) LOCAL_XRT="$2"    ; shift 2 ;;
            -p|--platform        ) PLATFORM_ONLY="$2"; shift 2 ;;
            --skip-xrt-install   ) XRT=0             ; shift 1 ;;
            --skip-shell-flash   ) SHELL=0           ; shift 1 ;;
            --skip-xrm-install   ) XRM=0             ; shift 1 ;;
            -y|--yes             ) YES=1             ; shift 1 ;;
            --install-docker     ) INSTALL_DOCKER=1  ; shift 1 ;;
            -h|--help            ) usage             ; exit  1 ;;
            --combinations       ) list              ; exit  1 ;;
            ""                   ) break;;
            *) echo "ERROR: Invalid option: $1."; usage; exit 1 ;;
        esac
    done
fi

if [ $? != 0 ] ; then echo "ERROR: Failed parsing options." >&2 ; usage; exit 1 ; fi
if [[ "$XRT" == 0 && "$SHELL" == 0 && "$WIZARD" == 0 ]] ; then echo "ERROR: Please do NOT skip both XRT installation and card flashing." >&2 ; usage; exit 1 ; fi

cat doc/notice_disclaimer.txt
if [[ "$YES" != 1 ]]; then
    confirm
fi

main
