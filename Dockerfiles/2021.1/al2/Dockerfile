FROM amazonlinux:2
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN yum update; yum install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y tar

# Download XRT Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_2-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202110.2.11.634_2-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202110.1.2.1539_2-x86_64.rpm > ${PACKAGE_PATH}/xrm_202110.1.2.1539_2-x86_64.rpm;

# Download Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-1.noarch.rpm.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-noarch_1-3209015.rpm_2.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma-platform-3.1-1.noarch.rpm.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-platform-3.1-1.noarch.rpm.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-3246211.x86_64.rpm > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-3246211.x86_64.rpm; 

# Install XRT and modify the Path
RUN XRT_VERSION="202110.2.11.634"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_2-x86_64-xrt.rpm; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202110.1.2.1539";\
    yum install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_2-x86_64.rpm

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py;
RUN echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc
RUN ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl
RUN export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
