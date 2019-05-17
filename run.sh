#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
  echo "Usage:"
  echo "./run.sh     --platform <platform> --version <version> --os-version <os-version>"
  echo "./deploy.sh   -p        <platform>  -v       <version>  -o          <os-version>"
  echo "<platform> : alveo-u200 / alveo-u250"
  echo "<version>  : 2018.3 / 2018.2"
  echo "<os-version>     : ubuntu-18.04 / unbunt-16.04 / centos"

}

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

while true
do
case "$1" in
	-p|--platform        ) PLATFORM="$2"     ; shift 2 ;;
	-v|--version         ) VERSION="$2"      ; shift 2 ;;
	-o|--os-version      ) OSVERSION="$2"    ; shift 2 ;;
	-h|--help            ) usage             ; exit  1 ;;
*) break ;;
esac
done

if [[ "$PLATFORM" == "alveo-u200" ]]; then
	if [[ "$VERSION" == "2018.3" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2018-3-ubuntu-18-04"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2018-3-ubuntu-16-04"
		elif [["$OSVERSION" == "centos"]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2018-3-centos"
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
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2018-3-ubuntu-18-04"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2018-3-ubuntu-16-04"
		elif [["$OSVERSION" == "centos"]]; then
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2018-3-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
	# elif [[ "$VERSION" == "2018.2" ]]; then
	else
		echo "Unspport version! "
		exit 1
	fi
else
	echo "Unspport platform! "
	exit 1
fi

docker run \
	--rm \
	--privileged=true \
	-it $DOCKER_IMAGE \
	/bin/bash