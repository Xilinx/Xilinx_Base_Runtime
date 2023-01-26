FROM centos:7
ARG PACKAGE_PATH=/root/xilinx_packages

RUN yum update; yum install -y wget; mkdir -p ${PACKAGE_PATH}
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2250_7.4.1708-xrt.rpm > ${PACKAGE_PATH}/xrt_201910.2.2.2250_7.4.1708-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_7.4.1708-xrt.rpm > ${PACKAGE_PATH}/xrt_201920.2.3.1301_7.4.1708-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.5.309_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_201920.2.5.309_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202010.2.7.766_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm;

# Install XRT and modify the Path
RUN XRT_VERSION="201910.2.2.2250"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.3.1301"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.5.309"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202010.2.7.766"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202020.1.1.1016_7.4.1708-x86_64.rpm > \
    ${PACKAGE_PATH}/xrm_202020.1.1.1016_7.4.1708-x86_64.rpm; \
    yum install -y ${PACKAGE_PATH}/xrm_202020.1.1.1016_7.4.1708-x86_64.rpm

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc


#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt
