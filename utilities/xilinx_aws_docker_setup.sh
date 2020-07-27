#!/bin/bash
# Script to setup docker environment for Xilinx AWS docker app

export LANG=en_US.UTF-8 && export LANGUAGE=en_US.UTF-8 && export LC_COLLATE=C && export LC_CTYPE=en_US.UTF-8

if [ ! "$BASH_VERSION" ] ; then
    echo "Please do not use sh to run this script ($0), just execute it directly" 1>&2
    exit 1
fi

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

DEVICES="$DEVICES --mount type=bind,source=/sys/bus/pci/devices/0000:00:1d.0,target=/sys/bus/pci/devices/0000:00:1d.0"
DEVICES="$DEVICES --mount type=bind,source=/sys/bus/pci/devices/0000:00:1e.0,target=/sys/bus/pci/devices/0000:00:1e.0"


export XILINX_AWS_DOCKER_DEVICES=$DEVICES

echo "XILINX_AWS_DOCKER_DEVICES : $XILINX_AWS_DOCKER_DEVICES"

sudo systemctl start mpd || exit 1