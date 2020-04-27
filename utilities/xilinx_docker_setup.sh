#!/bin/bash
# Script to setup docker environment for Xilinx docker app

source /opt/xilinx/xrt/setup.sh

DEVICES=""
for xclf in /dev/xclmgmt*
do
    DEVICES="$DEVICES --device=$xclf:$xclf"
done
for usrf in /dev/dri/renderD*
do
    DEVICES="$DEVICES --device=$usrf:$usrf"
done

export XILINX_DOCKER_DEVICES=$DEVICES

echo "XILINX_DOCKER_DEVICES : $XILINX_DOCKER_DEVICES"