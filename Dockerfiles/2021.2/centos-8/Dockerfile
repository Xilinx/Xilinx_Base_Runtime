FROM centos:8
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN yum upgrade; yum install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell
RUN yum install -y dnf-plugins-core
RUN yum config-manager --set-enabled powertools
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum config-manager --set-enabled appstream

# Download XRT Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202010.2.7.766_8.1.1911-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.9.317_8.1.1911-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202110.2.11.634_8.1.1911-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202120.2.12.427_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202120.2.12.427_8.1.1911-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202120.1.3.29_8.1.1911-x86_64.rpm > ${PACKAGE_PATH}/xrm_202120.1.3.29_8.1.1911-x86_64.rpm;

# Download u50 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz > /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz;

# Download u200 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-xdma-201830.2-2580015.x86_64.rpm > /opt/xilinx/shell/xilinx-u200-xdma-201830.2-2580015.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz;

# Download u250 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-xdma-201830.2-2580015.x86_64.rpm > /opt/xilinx/shell/xilinx-u250-xdma-201830.2-2580015.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma-noarch_3.1-3063142.rpm_2.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-noarch_3.1-3063142.rpm_2.tar.gz;

# Download u280 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-2789161.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-2789161.x86_64.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-3246211.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-3246211.x86_64.rpm;

# Untar relevant shell packages
RUN cd /opt/xilinx/shell; \
    tar -zxvf /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_noarch_rpm.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-noarch_3.1-3063142.rpm_2.tar.gz; \
    rm /opt/xilinx/shell/*.tar.gz;

# Install XRT and modify the Path
RUN XRT_VERSION="202010.2.7.766"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202110.2.11.634"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; 
    
RUN XRT_VERSION="202120.2.12.427"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202120.1.3.29"; \
    yum install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_8.1.1911-x86_64.rpm

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py;
RUN echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc
RUN ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl
RUN export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
