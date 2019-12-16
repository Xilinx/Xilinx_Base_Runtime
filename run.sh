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

}

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

list() {
    echo "Available Docker Images:"
    echo ""
    echo "Image Name                     Support Platform              Version      OS Version"
    echo "alveo-2018-3-centos            Alveo U200 / U250             2018.3       CentOS"
    echo "alveo-2018-3-ubuntu-1604       Alveo U200 / U250             2018.3       Ubuntu 16.04"
    echo "alveo-2018-3-ubuntu-1804       Alveo U200 / U250             2018.3       Ubuntu 18.04"
    echo "alveo-2019-1-centos            Alveo U200 / U250 / U280      2019.1       CentOS"
    echo "alveo-2019-1-ubuntu-1604       Alveo U200 / U250 / U280      2019.1       Ubuntu 16.04"
    echo "alveo-2019-1-ubuntu-1804       Alveo U200 / U250 / U280      2019.1       Ubuntu 18.04"
    echo "alveo-2019-2-centos            Alveo U200 / U250 / U280      2019.2       CentOS"
    echo "alveo-2019-2-ubuntu-1604       Alveo U200 / U250 / U280      2019.2       Ubuntu 16.04"
    echo "alveo-2019-2-ubuntu-1804       Alveo U200 / U250 / U280      2019.2       Ubuntu 18.04"
}

COMMAND="/bin/bash"
PLATFORM="alveo-u200"

/opt/xilinx/xrt/bin/xbutil list > /dev/null
if [ $? != 0 ] ; then
	echo "Please check XRT is installed and Shell is flashed on FPGA. See:"
	echo "/opt/xilinx/xrt/bin/xbutil list"
	echo ""
	echo "You can use host_setup.sh to install and flash. "
	exit 1
fi


while true
do
case "$1" in
	-v|--version         ) VERSION="$2"      ; shift 2 ;;
	-o|--os-version      ) OSVERSION="$2"    ; shift 2 ;;
	-c                   ) COMMAND="$2"      ; shift 2 ;;
	-h|--help            ) usage             ; exit  1 ;;
*) break ;;
esac
done


COMB="${PLATFORM}_${VERSION}_${OSVERSION}"

if grep -q $COMB "conf/spec.txt"; then
    DOCKER_IMAGE=`grep ^$COMB: conf/spec.txt | awk -F':' '{print $2}' | awk -F';' '{print $5}' | awk -F= '{print $2}'`
else
    usage
    echo ""
    list
    exit 1
fi

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

#Update docker image
echo "Pull docker image"
docker pull $DOCKER_IMAGE


echo "Run docker as:"
echo "docker run --rm $DEVICES -it $DOCKER_IMAGE /bin/bash -c $COMMAND"
docker run \
	--rm \
	$DEVICES \
	-it \
	$DOCKER_IMAGE \
	/bin/bash -c \
	"$COMMAND"

