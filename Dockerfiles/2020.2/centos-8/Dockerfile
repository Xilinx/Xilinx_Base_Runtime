FROM centos:8.1.1911

#Install dependencies
RUN yum install -y epel-release wget; 

#Dowload XRT installation packages from Xilinx lounge page
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.8.726_8.1.1911-x86_64-xrt.rpm > /root/xrt_202020.2.8.726_8.1.1911-x86_64-xrt.rpm

#Install XRT 
RUN yum install --enablerepo=PowerTools -y /root/xrt_202020.2.8.726_8.1.1911-x86_64-xrt.rpm

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt