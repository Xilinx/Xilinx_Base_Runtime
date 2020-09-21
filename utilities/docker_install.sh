#!/usr/bin/env bash
#
# (C) Copyright 2020, Xilinx, Inc.
#
#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. " 
   exit 1
fi

OSVERSION=`grep '^ID=' /etc/os-release | awk -F= '{print $2}' | tr -d '"'`

if [[ "$OSVERSION" == "ubuntu" ]]; then
	DOCKER_INFO=`apt list --installed 2>/dev/null | grep docker-ce`
elif [[ "$OSVERSION" == "centos" ]]; then
	DOCKER_INFO=`yum list installed 2>/dev/null | grep docker-ce`
else
	echo "The script supports: Ubuntu 16.04, Ubuntu 18.04 and Centos 7. For other operating system, please install DockerCE manually following: https://docs.docker.com/engine/install/."
	exit 1
fi

if [ $? == 0 ] ; then
	echo "You have already installed docker."
	DOCKER_INFO=`docker info 2>/dev/null`
	if [ $? == 0 ] ; then
		DOCKER_VERSION=`docker info 2>/dev/null |grep "Server Version"| awk -F: '{print $2}'`
		echo "Docker Version:$DOCKER_VERSION"
	else
		docker info
		echo "Please run following command if docker daemon is not running:"
		echo "    sudo systemctl start docker"
	fi
else
	echo "Install docker on $OSVERSION..."
	if [[ "$OSVERSION" == "ubuntu" ]]; then
		apt-get -y update && apt-get install -y curl
	fi
	curl -fsSL https://get.docker.com | sh > /tmp/xxappstore_hostsetup_installdocker.log 2>&1
	if [[ $? != 0 ]]; then
		echo "[ERROR] Unable to install DockerCE using Docker automated script"
		echo "Please install DockerCE manually following this documentation:"
		if [[ "$OSVERSION" == "ubuntu" ]]; then
			echo ' > [UBUNTU] https://docs.docker.com/install/linux/docker-ce/ubuntu/'
		elif [[ "$OSVERSION" == "centos" ]]; then
			echo ' > [CENTOS] https://docs.docker.com/install/linux/docker-ce/centos/'
		fi
		exit 1
	fi
	echo "Configure docker"
	mkdir -p /etc/docker && echo '{"max-concurrent-downloads": 1}' | tee -a /etc/docker/daemon.json && systemctl restart docker && systemctl enable docker > /tmp/xxappstore_hostsetup_configuredocker.log 2>&1
	if [[ $? != 0 ]]; then
		echo "[ERROR] Docker Configuration. Check log file /tmp/xxappstore_hostsetup_configuredocker.log"
		exit 1
	fi
	echo "Verify that Docker Engine is installed correctly by running the hello-world image."
	echo ""
	echo "    docker run hello-world"
	echo ""
	echo "If you would like to use Docker as a non-root user, you should now consider adding your user to the “docker” group with something like:"
	echo ""
	echo "    usermod -aG docker your-user"
	echo ""
	echo "Install docker completed"
fi