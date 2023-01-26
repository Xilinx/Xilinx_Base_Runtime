FROM centos:7
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN yum update; yum install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2250_7.4.1708-xrt.rpm > ${PACKAGE_PATH}/xrt_201910.2.2.2250_7.4.1708-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_7.4.1708-xrt.rpm > ${PACKAGE_PATH}/xrt_201920.2.3.1301_7.4.1708-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.5.309_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_201920.2.5.309_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202010.2.6.655_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202010.2.7.766_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.8.832_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.8.832_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_7.6.1810-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202110.2.11.634_7.6.1810-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202120.2.12.427_7.8.2003-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202120.2.12.427_7.8.2003-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202210.2.13.466_7.8.2003-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202210.2.13.466_7.8.2003-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202220.2.14.354_7.8.2003-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202220.2.14.354_7.8.2003-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202220.1.5.212_7.8.2003-x86_64.rpm > ${PACKAGE_PATH}/xrm_202220.1.5.212_7.8.2003-x86_64.rpm;

# Install XRT and modify the Path
RUN XRT_VERSION="201910.2.2.2250"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="201920.2.3.1301"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="201920.2.5.309"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202010.2.6.655"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202010.2.7.766"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202020.2.8.832"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202020.2.9.317"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202110.2.11.634"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.6.1810-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202120.2.12.427"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.8.2003-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202210.2.13.466"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.8.2003-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202220.2.14.354"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.8.2003-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202220.1.5.212"; \
    yum install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_7.8.2003-x86_64.rpm

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; \
    echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc; \
    ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl; \
    export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
COPY .bashrc /root/.bashrc
