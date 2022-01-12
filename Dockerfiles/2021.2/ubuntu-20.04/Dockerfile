FROM ubuntu:20.04
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN apt-get update; apt-get install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202020.2.9.317_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202110.2.11.634_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202120.2.12.427_20.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202120.2.12.427_20.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202120.1.3.29_20.04-x86_64.deb > ${PACKAGE_PATH}/xrm_202120.1.3.29_20.04-x86_64.deb;

# Download u50 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma-all_1-2784799.deb.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-all_1-2784799.deb.tar.gz;

# Download u200 XRT Shell Pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz;

# Download u250 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma-all_3.1-3063142.deb_2.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-all_3.1-3063142.deb_2.tar.gz;

# Untar relevant shell packages
RUN cd /opt/xilinx/shell; \
    tar -zxvf /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-all_1-2784799.deb.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-all_3.1-3063142.deb_2.tar.gz; \
    rm /opt/xilinx/shell/*.tar.gz

# Install XRT and modify the Path
RUN XRT_VERSION="202020.2.9.317"; \
    apt-get update; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202110.2.11.634"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; 
    
RUN XRT_VERSION="202120.2.12.427"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_20.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202120.1.3.29"; \
    apt-get install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_20.04-x86_64.deb

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py;
RUN echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc
RUN ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl
RUN export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh
