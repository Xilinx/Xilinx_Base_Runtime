FROM centos:7

#Install dependencies
RUN yum install -y epel-release wget; 

#Dowload XRT installation packages from Xilinx lounge page
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_7.4.1708-x86_64-xrt.rpm > /root/xrt_202010.2.6.655_7.4.1708-x86_64-xrt.rpm

#Install XRT 
RUN yum install -y /root/xrt_202010.2.6.655_7.4.1708-x86_64-xrt.rpm

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt