FROM ubuntu:16.04
ARG PACKAGE_PATH=/root/xilinx_packages

RUN apt-get update; apt-get install -y wget; mkdir -p ${PACKAGE_PATH}

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201910.2.2.2250_16.04-xrt.deb > ${PACKAGE_PATH}/xrt_201910.2.2.2250_16.04-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_16.04-xrt.deb > ${PACKAGE_PATH}/xrt_201920.2.3.1301_16.04-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.5.309_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_201920.2.5.309_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202010.2.7.766_16.04-amd64-xrt.deb; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_16.04-amd64-xrt.deb > ${PACKAGE_PATH}/xrt_202020.2.9.317_16.04-amd64-xrt.deb;

# Install XRT and modify the Path
RUN XRT_VERSION="201910.2.2.2250"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.3.1301"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="201920.2.5.309"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202010.2.7.766"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    apt-get install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_16.04-amd64-xrt.deb; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrm_202020.1.1.1016_16.04-x86_64.deb > \
    ${PACKAGE_PATH}/xrm_202020.1.1.1016_16.04-x86_64.deb; \
    apt-get install -y ${PACKAGE_PATH}/xrm_202020.1.1.1016_16.04-x86_64.deb

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc


#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt
