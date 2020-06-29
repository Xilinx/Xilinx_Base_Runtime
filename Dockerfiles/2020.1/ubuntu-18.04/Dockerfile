FROM ubuntu:18.04

#Install dependencies
RUN apt-get update; apt-get install -y wget

#Dowload XRT installation packages from Xilinx lounge page
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_18.04-amd64-xrt.deb > /root/xrt_202010.2.6.655_18.04-amd64-xrt.deb

#Install XRT
RUN apt-get update; apt-get install -y /root/xrt_202010.2.6.655_18.04-amd64-xrt.deb

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt