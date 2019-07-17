#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

usage() {
  echo "Usage:"
  echo "./deploy.sh --install-xrt --install-shell --platform <platform> --version <version> --os-version <os-version>"
  echo "./deploy.sh  -x            -s              -p <platform>         -v       <version>  -o <os-version>"
  echo "-x               : install XRT"
  echo "-s               : install Shell and flash card"
  echo "<platform>       : alveo-u200 / alveo-u250 / alveo-u280"
  echo "<version>        : 2018.3 / 2019.1"
  echo "<os-version>     : ubuntu-18.04 / ubuntu-16.04 / centos"

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
			XRT_PACKAGE="xrt_201830.2.1.1794_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_18.04.deb"
			DSA="xilinx_u200_xdma_201830_2"
			TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201830.2.1.1794_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_16.04.deb"
			DSA="xilinx_u200_xdma_201830_2"
			TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-ubuntu-1604"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201830.2.1.1794_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015.x86_64.rpm"
			DSA="xilinx_u200_xdma_201830_2"
			$TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-201830-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
	elif [[ "$VERSION" == "2019.1" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_18.04.deb"
			DSA="xilinx_u200_xdma_201830_2"
			TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015_16.04.deb"
			DSA="xilinx_u200_xdma_201830_2"
			TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-ubuntu-1604"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u200-xdma-201830.2-2580015.x86_64.rpm"
			DSA="xilinx_u200_xdma_201830_2"
			$TIMESTAMP="-t 1561465320"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u200-2019-1-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
	else
		echo "Unspport version! "
		exit 1
	fi
elif [[ "$PLATFORM" == "alveo-u250" ]]; then
	if [[ "$VERSION" == "2018.3" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			XRT_PACKAGE="xrt_201830.2.1.1794_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_18.04.deb"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201830.2.1.1794_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_16.04.deb"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-ubuntu-1604"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201830.2.1.1794_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015.x86_64.rpm"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-201830-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
	elif [[ "$VERSION" == "2019.1" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_18.04.deb"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015_16.04.deb"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-ubuntu-1604"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u250-xdma-201830.2-2580015.x86_64.rpm"
			DSA="xilinx_u250_xdma_201830_2"
			TIMESTAMP="-t 1561656294"
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u250-2019-1-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
	else
		echo "Unspport version! "
		exit 1
	fi
elif [[ "$PLATFORM" == "alveo-u280" ]]; then
	if [[ "$VERSION" == "2019.1" ]]; then
		if [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_18.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327_18.04.deb"
			DSA="xilinx_u280_xdma_201910_1"
			TIMESTAMP=""
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1804"
		elif [[ "$OSVERSION" == "ubuntu-16.04" ]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_16.04-xrt.deb"
			SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327_16.04.deb"
			DSA="xilinx_u280_xdma_201910_1"
			TIMESTAMP=""
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-ubuntu-1604"
		elif [["$OSVERSION" == "centos"]]; then
			XRT_PACKAGE="xrt_201910.2.2.2173_7.4.1708-xrt.rpm"
			SHELL_PACKAGE="xilinx-u280-xdma-201910.1-2579327.x86_64.rpm"
			DSA="xilinx_u280_xdma_201910_1"
			TIMESTAMP=""
			DOCKER_IMAGE="xdock.xilinx.com/xsds:alveo-u280-2019-1-centos"
		else
			echo "Unspport Operating System! "
			exit 1
		fi
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

if [[ "$SHELL" == 1 ]]; then
	COPY_COMMAND="$COPY_COMMAND cp /root/$SHELL_PACKAGE /tmp;"
fi

if [ -z "$COPY_COMMAND" ] ; then echo "Please select XRT or Shell or both to install." >&2 ; usage; exit 1 ; fi

echo "Copy XRT and Shell from docker container. "
docker run --rm  \
	-v /tmp:/tmp  \
	-it   $DOCKER_IMAGE \
	/bin/bash -c "$COPY_COMMAND"

if [[ "$XRT" == 1 ]]; then
	echo "Install XRT"
	if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
		sudo apt-get install /tmp/$XRT_PACKAGE
	# elif [[ "$OSVERSION" == "redhat" ]]; then
	# 		yum-config-manager --enable rhel-7-server-optional-rpms
	# 		yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	elif [[ "$OSVERSION" == "centos" ]]; then
		sudo yum install epel-release
	fi
	rm /tmp/$XRT_PACKAGE
fi

if [[ "$SHELL" == 1 ]]; then
	echo "Install Shell"
	if [[ "$OSVERSION" == "ubuntu-16.04" ]] || [[ "$OSVERSION" == "ubuntu-18.04" ]]; then
		sudo apt-get install /tmp/$SHELL_PACKAGE
	elif [[ "$OSVERSION" == "centos" ]]; then
		sudo rpm -i /tmp/$SHELL_PACKAGE
	fi
	rm /tmp/$SHELL_PACKAGE
	
	echo "Flash Card"
	sudo /opt/xilinx/xrt/bin/xbutil flash -a $DSA -t $TIMESTAMP
fi
