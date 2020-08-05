#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
    echo "Running run.sh to start a docker container for XRT runtime. "
    echo ""
    echo "Usage:"
    echo "./run.sh      --version <version> --os-version <os-version>"
    echo "./run.sh       -v       <version>  -o          <os-version>"
    echo "<version>      : 2018.3 / 2019.1 / 2019.2"
    echo "<os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos"
    echo ""
    echo "Example:"
    echo "Start docker container whith 2019.2 XRT on Ubuntu 18.04"
    echo "  ./run.sh -v 2019.2 -o ubuntu-18.04"
    echo ""
    echo "Additional parameters: "
    echo "-c [command] : Execute specific command when start docker container"
    echo "--pull       : Pull docker image before run"

}


list() {
    echo "Available Docker Images:"
    echo ""
    echo "Image Name                     Support Platform                    Version      OS Version"
    echo "alveo-2018-3-centos            Alveo U200 / U250                   2018.3       CentOS"
    echo "alveo-2018-3-ubuntu-1604       Alveo U200 / U250                   2018.3       Ubuntu 16.04"
    echo "alveo-2018-3-ubuntu-1804       Alveo U200 / U250                   2018.3       Ubuntu 18.04"
    echo "alveo-2019-1-centos            Alveo U200 / U250 / U280            2019.1       CentOS"
    echo "alveo-2019-1-ubuntu-1604       Alveo U200 / U250 / U280            2019.1       Ubuntu 16.04"
    echo "alveo-2019-1-ubuntu-1804       Alveo U200 / U250 / U280            2019.1       Ubuntu 18.04"
    echo "alveo-2019-2-centos            Alveo U200 / U250 / U280 / U50      2019.2       CentOS"
    echo "alveo-2019-2-ubuntu-1604       Alveo U200 / U250 / U280 / U50      2019.2       Ubuntu 16.04"
    echo "alveo-2019-2-ubuntu-1804       Alveo U200 / U250 / U280 / U50      2019.2       Ubuntu 18.04"
    echo "alveo-2020-1-centos            Alveo U200 / U250 / U280 / U50      2020.1       CentOS"
    echo "alveo-2020-1-ubuntu-1604       Alveo U200 / U250 / U280 / U50      2020.1       Ubuntu 16.04"
    echo "alveo-2020-1-ubuntu-1804       Alveo U200 / U250 / U280 / U50      2020.1       Ubuntu 18.04"
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

check_docker() {
    DOCKER_INFO=`docker info 2>/dev/null`
    if [ $? == 0 ] ; then
        return 0
    fi
    OSVERSION=`grep '^ID=' /etc/os-release | awk -F= '{print $2}' | tr -d '"'`

    if [[ "$OSVERSION" == "ubuntu" ]]; then
        DOCKER_INFO=`apt list --installed 2>/dev/null | grep docker-ce`
    elif [[ "$OSVERSION" == "centos" ]]; then
        DOCKER_INFO=`yum list installed 2>/dev/null | grep docker-ce`
    else
        return 0
    fi
    if [ $? == 0 ] ; then
        DOCKER_INFO=`docker info 2>/dev/null`
        if [ $? != 0 ] ; then
            docker info
            return 1
        fi
    else
        echo "Docker is NOT installed. Please run "
        echo "    ./utilities/docker_install.sh"
        echo "to install docker service. "
        return 1
    fi
}

notice_disclaimer
confirm 

COMMAND="/bin/bash"
PLATFORM="alveo-u200"
UPDATE=0

/opt/xilinx/xrt/bin/xbutil list > /dev/null
if [ $? != 0 ] ; then
	echo "Please check XRT is installed and Shell is flashed on FPGA. See:"
	echo "/opt/xilinx/xrt/bin/xbutil list"
	echo ""
	echo "You can use host_setup.sh to install and flash. "
	exit 1
fi

check_docker

if [[ $? != 0 ]]; then
    exit 1
fi

while true
do
case "$1" in
	-v|--version         ) VERSION="$2"      ; shift 2 ;;
	-o|--os-version      ) OSVERSION="$2"    ; shift 2 ;;
	-c                   ) COMMAND="$2"      ; shift 2 ;;
	--pull               ) UPDATE=1          ; shift 1 ;;
	-h|--help            ) usage             ; exit  1 ;;
*) break ;;
esac
done

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

if [[ "$VERSION" == "2019.1" ]]; then
    read -r -p "${1:-Is this for U50? [y/n]:} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            PLATFORM="alveo-u50"
            ;;
        *)
            ;;
    esac
fi

COMB="${PLATFORM}_${VERSION}_${OSVERSION}"

if grep -q $COMB "conf/spec.txt"; then
    IMAGE_TAG=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $5}' | awk -F= '{print $2}'`
else
    usage
    echo ""
    list
    exit 1
fi

DOCKER_IMAGE="xilinx/xilinx_runtime_base:$IMAGE_TAG"

# Mapping XRT user function and management function
DEVICES=""
for xclf in /dev/xclmgmt*
do
	DEVICES="$DEVICES --device=$xclf:$xclf"
done
for usrf in /dev/dri/renderD*
do
	DEVICES="$DEVICES --device=$usrf:$usrf"
done

if [[ "$UPDATE" == 1 ]]; then
	#Update docker image
	echo "Pull docker image: $DOCKER_IMAGE"
	docker pull $DOCKER_IMAGE
fi


echo "Run docker as:"
echo "docker run --rm $DEVICES -it $DOCKER_IMAGE"
docker run \
	--rm \
	$DEVICES \
	-it \
	$DOCKER_IMAGE \
	/bin/bash -c \
	"$COMMAND"

