#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
  echo "Usage:"
  echo "./deploy.sh --install-xrt --install-shell --platform <platform> --version <version> --os-version <os-version>"
  echo "./deploy.sh  -x            -s              -p <platform>         -v       <version>  -o <os-version>"
  echo "-x install XRT"
  echo "-s install Shell and flash card"
  echo "<platform> : alveo-u200 / alveo-u250"
  echo "<version>  : 2018.3 / 2018.2"
  echo "<os-version>     : ubuntu-18.04 / unbunt-16.04 / centos"

}

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage; exit 1 ; fi

while true
do
case "$1" in
	-x|--install-xrt     ) XRT=1             ; shift 1 ;;
	-s|--install-shell   ) SHELL=1           ; shift 1 ;;
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
			XRT_PACKAGE="xrt_201830.2.1.1712_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.1_18.04.deb"
			DSA="xilinx_u200_xdma_201830_1"
			TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201830.2.1.1712_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.1_16.04.deb"
			DSA="xilinx_u200_xdma_201830_1"
			TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201830.2.1.1712_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.1-2405991.x86_64.rpm"
			DSA="xilinx_u200_xdma_201830_1"
			$TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
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
			XRT_PACKAGE="xrt_201830.2.1.1712_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.1_18.04.deb"
			DSA="xilinx_u250_xdma_201830_1"
			TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201830.2.1.1712_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.1_16.04.deb"
			DSA="xilinx_u250_xdma_201830_1"
			TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201830.2.1.1712_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.1-2405991.x86_64.rpm"
			DSA="xilinx_u250_xdma_201830_1"
			TIMESTAMP="1542625200"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-18-04"
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

COPY_COMMAND=""
if [[ "$XRT" == 1 ]]; then
	COPY_COMMAND="cp /root/$XRT_PACKAGE /tmp;"
fi

if [[ "$SHELL" ==1 ]]; then
	COPY_COMMAND="$COPY_COMMAND cp /root/$SHELL_PACKAGE /tmp;"
fi

if [ -z "$COPY_COMMAND" ] ; then echo "Please select XRT or Shell or both to install." >&2 ; usage; exit 1 ; fi

echo "Copy XRT and Shell from docker container. "
docker run --rm  \
	--privileged=true \
	-v /tmp:/tmp  \
	-it   $DOCKER_IMAGE \
	/bin/bash -c "$COPY_COMMAND"

if [[ "$XRT" == 1 ]]; then
	echo "Install XRT"
	if [[ "$OSVERSION" == 'unbunt-16.04' ]] || [[ "$OSVERSION" == 'unbunt-18.04' ]]; then
		apt-get install /tmp/$XRT_PACKAGE
	# elif [[ "$OSVERSION" == 'redhat' ]]; then
	# 		yum-config-manager --enable rhel-7-server-optional-rpms
	# 		yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	elif [[ "$OSVERSION" == 'centos' ]]; then
			yum install epel-release
	fi
	rm /tmp/$XRT_PACKAGE
fi

if [[ "$XRT" == 1 ]]; then
	echo "Install XRT"
	if [[ "$OSVERSION" == 'unbunt-16.04' ]] || [[ "$OSVERSION" == 'unbunt-18.04' ]]; then
		apt-get install /tmp/$XRT_PACKAGE
	# elif [[ "$OSVERSION" == 'redhat' ]]; then
	# 		yum-config-manager --enable rhel-7-server-optional-rpms
	# 		yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	# 		rpm -i /tmp/$XRT_PACKAGE
	elif [[ "$OSVERSION" == 'centos' ]]; then
			yum install epel-release
			rpm -i /tmp/$XRT_PACKAGE
	fi
	rm /tmp/$XRT_PACKAGE
fi

if [[ "$SHELL" == 1 ]]; then
	echo "Install Shell"
	if [[ "$OSVERSION" == 'unbunt-16.04' ]] || [[ "$OSVERSION" == 'unbunt-18.04' ]]; then
		apt-get install /tmp/$SHELL_PACKAGE
	elif [[ "$OSVERSION" == 'centos' ]]; then
		rpm -i /tmp/$XRT_PACKAGE
	fi
	rm /tmp/$XRT_PACKAGE
	
	echo "Flash Card"
	/opt/xilinx/xrt/bin/xbutil flash -a $DSA -t $TIMESTAMP
fi
