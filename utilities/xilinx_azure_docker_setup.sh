#!/bin/bash
# Script to setup docker environment for Xilinx docker app

# Make sure this script is sourced
script=${BASH_SOURCE[0]}
if [ $script == $0 ]; then
    echo "ERROR: You must source this script"
    exit 2
fi

source /opt/xilinx/xrt/setup.sh

DEVICES=""
for usrf in /dev/dri/renderD*
do
    DEVICES="$DEVICES --device=$usrf:$usrf"
done

export XILINX_AZ_DOCKER_DEVICES=$DEVICES

echo "XILINX_AZ_DOCKER_DEVICES : $XILINX_AZ_DOCKER_DEVICES"

