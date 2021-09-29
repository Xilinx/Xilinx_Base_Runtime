FROM ubuntu:16.04
ARG PACKAGE_PATH=/tmp/xilinx_packages
RUN apt-get update; apt-get install -y wget; mkdir -p ${PACKAGE_PATH}; mkdir -p /opt/xilinx/shell

# Download XRT Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2250_16.04-xrt.deb > ${PACKAGE_PATH}/xrt_201910.2.2.2250_16.04-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_16.04-xrt.deb > ${PACKAGE_PATH}/xrt_201920.2.3.1301_16.04-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.5.309_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_201920.2.5.309_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202010.2.7.766_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202020.2.9.317_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202110.2.11.634_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202110.2.11.634_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202110.1.2.1539_16.04-x86_64.deb > ${PACKAGE_PATH}/xrm_202110.1.2.1539_16.04-x86_64.deb;

# Download u50 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-xdma-201910.1-0911_16.04.deb > /opt/xilinx/shell/xilinx-u50-xdma-201910.1-0911_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-xdma-201920.1-2699728_16.04.deb > /opt/xilinx/shell/xilinx-u50-xdma-201920.1-2699728_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=Xilinx_u50-gen3x16-xdma-201920.3-2784799_16.04_deb.tar.gz > /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_16.04_deb.tar.gz; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u50-gen3x16-xdma-201920_3-3_all.deb.tar.gz > /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-3_all.deb.tar.gz;

# Download u200 XRT Shell Pacakges
RUN wget -cO - https://www.xilinx.com/member/forms/download/eula-xef.html?filename=xilinx-u200-xdma-16.04.deb > /opt/xilinx/shell/xilinx-u200-xdma-16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-xdma-201830.2-2580015_16.04.deb > /opt/xilinx/shell/xilinx-u200-xdma-201830.2-2580015_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz > /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz;

# Download u250 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/member/forms/download/eula-xef.html?filename=xilinx-u250-xdma-16.04.deb > /opt/xilinx/shell/xilinx-u250-xdma-16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-xdma-201830.2-2580015_16.04.deb > /opt/xilinx/shell/xilinx-u250-xdma-201830.2-2580015_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u250-gen3x16-xdma-platform_3.1-1_all.deb.tar.gz > /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-platform_3.1-1_all.deb.tar.gz;

# Download u280 XRT Shell Packages
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201910.1-2579327_16.04.deb > /opt/xilinx/shell/xilinx-u280-xdma-201910.1-2579327_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.1-2699728_16.04.deb > /opt/xilinx/shell/xilinx-u280-xdma-201920.1-2699728_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-2789161_16.04.deb > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-2789161_16.04.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xilinx-u280-xdma-201920.3-3246211_16.04.deb > /opt/xilinx/shell/xilinx-u280-xdma-201920.3-3246211_16.04.deb;

# Untar relevant shell packages
RUN cd /opt/xilinx/shell; \
    tar -zxvf /opt/xilinx/shell/Xilinx_u50-gen3x16-xdma-201920.3-2784799_16.04_deb.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u50-gen3x16-xdma-201920_3-3_all.deb.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u200-gen3x16-xdma-all_1-3209015.deb_2.tar.gz; \
    tar -zxvf /opt/xilinx/shell/xilinx-u250-gen3x16-xdma-platform_3.1-1_all.deb.tar.gz; \
    rm /opt/xilinx/shell/*.tar.gz

# Install XRT and modify the Path
RUN XRT_VERSION="201910.2.2.2250"; \
    apt-get update; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-xrt.deb; \
    mkdir /opt/xilinx/xrt_versions; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.3.1301"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.5.309"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202010.2.7.766"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202110.2.11.634"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_versions\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_versions/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_versions/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN XRM_VERSION="202110.1.2.1539"; \
    apt-get install -y ${PACKAGE_PATH}/xrm_${XRM_VERSION}_16.04-x86_64.deb

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py;
RUN echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc
RUN ln -s /usr/local/share/docker-systemctl-replacement/files/docker/systemctl3.py /usr/local/bin/systemctl
RUN export PATH=/usr/local/bin/:$PATH

COPY auto_setup.sh /opt/xilinx/auto_setup.sh

