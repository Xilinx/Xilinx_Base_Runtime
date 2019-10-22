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
    echo "<version>      : 2018.3 / 2019.1"
    echo "<os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos"
    echo ""
    echo "Example:"
    echo "Start docker container whith 2019.1 XRT on Ubuntu 18.04"
    echo "  ./run.sh -v 2019.1 -o ubuntu-18.04"

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
}

COMMAND="/bin/bash"


/opt/xilinx/xrt/bin/xbutil list > /dev/null
if [ $? != 0 ] ; then
	echo "Please check XRT is installed and Shell is flashed on FPGA. "
	echo "You can use host_setup.sh to install and flash. "
	exit 1
fi


while true
do
case "$1" in
	-p|--platform        ) PLATFORM="$2"     ; shift 2 ;;
	-v|--version         ) VERSION="$2"      ; shift 2 ;;
	-o|--os-version      ) OSVERSION="$2"    ; shift 2 ;;
	-c                   ) COMMAND="$2"      ; shift 2 ;;
	-h|--help            ) usage             ; exit  1 ;;
*) break ;;
esac
done

if [[ "$PLATFORM" == "alveo-u200" ]]; then
	if [[ "$VERSION" == "2018.3" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1604"
		elif [[ "$OSVERSION" == "centos" ]]; then
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
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1604"
		elif [[ "$OSVERSION" == "centos" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-centos"
		else
			echo "Unsupported Operating System! "
			usage
			echo ""
			list
			exit 1
		fi
	# elif [[ "$VERSION" == "2018.2" ]]; then
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
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1604"
		elif [[ "$OSVERSION" == "centos" ]]; then
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
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1604"
		elif [[ "$OSVERSION" == "centos" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-centos"
		else
			echo "Unsupported Operating System! "
			usage
			echo ""
			list
			exit 1
		fi
	# elif [[ "$VERSION" == "2018.2" ]]; then
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
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1604"
		elif [[ "$OSVERSION" == "centos" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-centos"
		else
			echo "Unsupported Operating System! "
			usage
			echo ""
			list
			exit 1
		fi
	fi
else
	echo "Unsupported platform! "
	usage
	echo ""
	list
	exit 1
fi

echo "Pull docker image"
docker pull $DOCKER_IMAGE

docker run \
	--rm \
	--privileged=true \
	-it \
	$DOCKER_IMAGE \
	/bin/bash -c \
	"$COMMAND"

