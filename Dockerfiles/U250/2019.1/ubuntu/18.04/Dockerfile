FROM ubuntu:18.04

#Install dependencies
RUN apt-get update; apt-get install -y ocl-icd-opencl-dev libboost-dev libboost-filesystem-dev uuid-dev dkms libprotoc-dev protobuf-compiler libncurses5-dev lsb-release libxml2-dev libyaml-dev wget

#Dowload XRT and SHELL installation packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2173_18.04-xrt.deb > /root/xrt_201910.2.2.2173_18.04-xrt.deb
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-xdma-201830.2-2580015_18.04.deb > /root/xilinx-u250-xdma-201830.2-2580015_18.04.deb

#Install XRT and SHELL
RUN apt-get update; apt-get install -y /root/xrt_201910.2.2.2173_18.04-xrt.deb