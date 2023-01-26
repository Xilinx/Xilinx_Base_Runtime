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
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.8.832_7.4.1708-x86_64-azure.rpm > ${PACKAGE_PATH}/xrt_202020.2.8.832_7.4.1708-x86_64-azure.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.9.317_7.4.1708-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_7.6.1810-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202110.2.11.634_7.6.1810-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202110.1.2.1539_7.6.1810-x86_64.rpm > ${PACKAGE_PATH}/xrm_202110.1.2.1539_7.6.1810-x86_64.rpm;

# Download u50 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-xdma-201910.1-0911.x86_64.rpm > /opt/xilinx/shell/xilinx-u50-xdma-201910.1-0911.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-xdma-201920.1-2699728.x86_64.rpm > /opt/xilinx/shell/xilinx-u50-xdma-201920.1-2699728.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz > /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz;

# Download u200 XRT Shell Pacakges
RUN wget -cO - https://www.xilinx.com/member/forms/download/eula-xef.html?filename=xilinx-u200-xdma-201820.1-2342198.x86_64.rpm > /opt/xilinx/shell/xilinx-u200-xdma-201820.1-2342198.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-xdma-201830.2-2580015.x86_64.rpm > /opt/xilinx/shell/xilinx-u200-xdma-201830.2-2580015.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz;

# Download u250 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/member/forms/download/eula-xef.html?filename=xilinx-u250-xdma-201820.1-2342198.x86_64.rpm > /opt/xilinx/shell/xilinx-u250-xdma-201820.1-2342198.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-xdma-201830.2-2580015.x86_64.rpm > /opt/xilinx/shell/xilinx-u250-xdma-201830.2-2580015.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma-platform-3.1-1.noarch.rpm.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-platform-3.1-1.noarch.rpm.tar.gz; 
    
# Download u280 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201910.1-2579327.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201910.1-2579327.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.1-2699728.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.1-2699728.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-2789161.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-2789161.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-3246211.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-3246211.x86_64.rpm; 

# Untar relevant shell packages
RUN cd /opt/xilinx/shell; \
    tar -zxvf /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-platform-3.1-1.noarch.rpm.tar.gz; \
    rm /opt/xilinx/shell/*.tar.gz;

# Install XRT and modify the Path
RUN XRT_VERSION="201910.2.2.2250"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.3.1301"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.5.309"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202010.2.6.655"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202010.2.7.766"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.8.832"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-azure.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.4.1708-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202110.2.11.634"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_7.6.1810-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202110.1.2.1539";\
    yum install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_7.6.1810-x86_64.rpm

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py;
RUN echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc
RUN ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl
RUN export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
