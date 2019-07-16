#!/bin/bash

# Run test on xsjatg400, 2018.3 XRT, 201830_1 Shell, Ubuntu 18.04, U250
TEST_COMMAND="apt install /root/xilinx-u250-xdma-201830.1_18.04.deb; source /opt/xilinx/xrt/setup.sh; cd /opt/xilinx/dsa/xilinx_u250_xdma_201830_1/test; ./validate.exe verify.xclbin" 
SSH_COMMAND="cd $WORKSPACE; ./run.sh -p alveo-u250 -v 2018.3 -o ubuntu-18.04 -c '$TEST_COMMAND'"

ssh -t xsjatg400 $SSH_COMMAND
