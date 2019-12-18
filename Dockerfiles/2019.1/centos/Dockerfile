FROM centos:7

#Install dependencies
RUN yum install -y epel-release; yum install -y boost-devel boost-filesystem dkms libboost_filesystem-mt.so.1.53.0 libboost_filesystem.so.1.53.0 libboost_system-mt.so.1.53.0 libboost_system.so.1.53.0 libprotobuf.so.8 libuuid-devel libxml2-devel libyaml-0.so.2 libyaml-devel ncurses-devel ocl-icd-devel protobuf-compiler protobuf-devel redhat-lsb-core gcc wget libyaml-0.1.4-11.el7_0.x86_64

#Dowload XRT installation packages from Xilinx lounge page
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2250_7.4.1708-xrt.rpm > /root/xrt_201910.2.2.2250_7.4.1708-xrt.rpm

#Install XRT 
RUN rpm -i /root/xrt_201910.2.2.2250_7.4.1708-xrt.rpm

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt