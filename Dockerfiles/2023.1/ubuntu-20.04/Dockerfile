FROM ubuntu:20.04
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN apt-get update; apt-get install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202020.2.9.317_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202110.2.11.634_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202120.2.12.427_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202120.2.12.427_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202210.2.13.466_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202210.2.13.466_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202220.2.14.354_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202220.2.14.354_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202310.2.15.225_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202220.2.14.354_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202310.1.6.50044_ubuntu20.04-x86_64.deb > ${PACKAGE_PATH}/xrm_202310.1.6.50044_ubuntu20.04-x86_64.deb;

# Download u200 XRT Shell Pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    # Download u250 XRT Shell Packages
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    # Download u50 XRT Shell Packages
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    # Download u55c XRT Shell Packages
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u55c-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz > /opt/xilinx/shell/xilinx-u55c-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz;
# Untar relevant shell packages
RUN cd /opt/xilinx/shell; \
    tar -ozxvf /opt/xilinx/shell/xilinx-u200-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    tar -ozxvf /opt/xilinx/shell/xilinx-u250-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    tar -ozxvf /opt/xilinx/shell/xilinx-u50-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    tar -ozxvf /opt/xilinx/shell/xilinx-u55c-gen3x16-xdma_2022.1_2022_0415_2123-all.deb.tar.gz; \
    rm /opt/xilinx/shell/*.tar.gz

# Install XRT and modify the Path
RUN XRT_VERSION="202020.2.9.317"; \
    apt-get update; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202110.2.11.634"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202120.2.12.427"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202210.2.13.466"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202220.2.14.354"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    XRT_VERSION="202310.2.15.225"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202310.1.6.50044"; \
    apt-get install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_ubuntu20.04-x86_64.deb

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; \
    echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc; \
    ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl; \
    export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
COPY .bashrc /root/.bashrc
