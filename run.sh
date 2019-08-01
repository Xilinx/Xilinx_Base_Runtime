#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
  echo "Usage:"
  echo "./run.sh     --platform <platform> --version <version> --os-version <os-version>"
  echo "./run.sh      -p        <platform>  -v       <version>  -o          <os-version>"
  echo "<platform>     : alveo-u200 / alveo-u250 / alveo-u280"
  echo "<version>      : 2018.3 / 2019.1"
  echo "<os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos"

}

COMMAND="/bin/bash"

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

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
			echo "Unspport Operating System! "
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
			echo "Unspport Operating System! "
			exit 1
		fi
	# elif [[ "$VERSION" == "2018.2" ]]; then
	else
		echo "Unspport version! "
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
			echo "Unspport Operating System! "
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
			echo "Unspport Operating System! "
			exit 1
		fi
	# elif [[ "$VERSION" == "2018.2" ]]; then
	else
		echo "Unspport version! "
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
			echo "Unspport Operating System! "
			exit 1
		fi
	fi
else
	echo "Unspport platform! "
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

