FROM ubuntu:16.04

#Install dependencies
RUN apt-get update; apt-get install -y ocl-icd-opencl-dev libboost-dev libboost-filesystem-dev uuid-dev dkms libprotoc-dev protobuf-compiler libncurses5-dev lsb-release libxml2-dev libyaml-dev

#Copy XRT and SHELL installation packages
COPY ./xrt_201830.2.1.1748_16.04-xrt.deb /root/
COPY ./xilinx-u200-xdma-201830.1_16.04.deb /root/

#Install XRT 
RUN apt-get update; apt-get install -y /root/rt_201830.2.1.1748_16.04-xrt.deb
