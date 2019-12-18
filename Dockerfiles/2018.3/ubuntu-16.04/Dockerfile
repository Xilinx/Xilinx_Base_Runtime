FROM ubuntu:16.04

#Install dependencies
RUN apt-get update; apt-get install -y ocl-icd-opencl-dev libboost-dev libboost-filesystem-dev uuid-dev dkms libprotoc-dev protobuf-compiler libncurses5-dev lsb-release libxml2-dev libyaml-dev wget

#Dowload XRT installation packages from Xilinx lounge page
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201830.2.1.1794_16.04-xrt.deb > /root/xrt_201830.2.1.1794_16.04-xrt.deb

#Install XRT 
RUN apt-get update; apt-get install -y /root/xrt_201830.2.1.1794_16.04-xrt.deb

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt