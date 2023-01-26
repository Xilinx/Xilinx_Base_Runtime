FROM centos:8
ARG PACKAGE_PATH=/root/xilinx_packages

RUN yum upgrade; yum install -y wget; mkdir -p ${PACKAGE_PATH}
RUN yum install dnf-plugins-core
RUN yum config-manager --set-enabled PowerTools
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum config-manager --set-enabled AppStream

# Download XRT pacakges
RUN wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.7.766_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202010.2.7.766_8.1.1911-x86_64-xrt.rpm; \
    wget -cO - https://www.xilinx.com/bin/public/openDownload?filename=xrt_202020.2.9.317_8.1.1911-x86_64-xrt.rpm > ${PACKAGE_PATH}/xrt_202020.2.9.317_8.1.1911-x86_64-xrt.rpm;

# Install XRT and modify the Path
RUN XRT_VERSION="202010.2.7.766"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh;

RUN XRT_VERSION="202020.2.9.317"; \
    yum install -y ${PACKAGE_PATH}/xrt_${XRT_VERSION}_8.1.1911-x86_64-xrt.rpm; \
    mv /opt/xilinx/xrt /opt/xilinx/xrt_${XRT_VERSION}; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.sh; \
    sed -i "s/\/opt\/xilinx\/xrt/\/opt\/xilinx\/xrt_$XRT_VERSION/" /opt/xilinx/xrt_${XRT_VERSION}/setup.csh; \
    ln -s /opt/xilinx/xrt_${XRT_VERSION} /opt/xilinx/xrt

# Download and install XRM package
# NOT BUILD FOR CENTOS 8.X YET

# Enalble Systemctl
RUN wget -cO - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/local/share/systemctl3.py; echo "alias systemctl='python3 /usr/local/share/systemctl3.py'" >> /root/.bashrc

#Copy notice and disclaimer
ADD Xilinx_notice_and_disclaimer.txt /Xilinx_notice_and_disclaimer.txt
