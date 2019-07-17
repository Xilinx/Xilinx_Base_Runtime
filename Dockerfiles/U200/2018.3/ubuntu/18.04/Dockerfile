FROM ubuntu:18.04

#Install dependencies
RUN apt-get update; apt-get install -y ocl-icd-opencl-dev libboost-dev libboost-filesystem-dev uuid-dev dkms libprotoc-dev protobuf-compiler libncurses5-dev lsb-release libxml2-dev libyaml-dev wget

#Dowload XRT and SHELL installation packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201830.2.1.1794_18.04-xrt.deb > /root/xrt_201830.2.1.1794_18.04-xrt.deb
wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-xdma-201830.2-2580015_18.04.deb > /root/xilinx-u200-xdma-201830.2-2580015_18.04.deb

RUN #Install XRT
RUN apt-get update; apt-get install -y /root/xrt_201830.2.1.1794_18.04-xrt.deb
