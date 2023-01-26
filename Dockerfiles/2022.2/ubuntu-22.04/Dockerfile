FROM ubuntu:22.04
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN apt-get update; apt-get install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202220.2.14.354_22.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202220.2.14.354_22.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202220.1.5.212_22.04-x86_64.deb > ${PACKAGE_PATH}/xrm_202220.1.5.212_22.04-x86_64.deb;

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
RUN XRT_VERSION="202220.2.14.354"; \
    apt-get update; \
    mkdir /opt/xilinx/xrt_versions; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_22.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202220.1.5.212"; \
    apt-get install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_22.04-x86_64.deb

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; \
    echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc; \
    ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl; \
    export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
COPY .bashrc /root/.bashrc
