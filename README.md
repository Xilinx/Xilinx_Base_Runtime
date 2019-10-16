# Software and SHELL deployment docker solution
## Description
This project provides unified docker images for several purposes: isolated runtime evniroment, installing XRT and Shell on host and as a base image for docker application. For more docker information, please refer [Docker Documentation](https://docs.docker.com). 
## Available Docker Images
![Docker Images](doc/docker_images.png)

Docker Images | Platform | Version | OS Version
------------- | -------- | ------- | ----------
alveo-u200-201830-centos      | Alveo U200 | 2018.3 | CentOS
alveo-u200-201830-ubuntu-1604 | Alveo U200 | 2018.3 | Ubuntu 16.04
alveo-u200-201830-ubuntu-1804 | Alveo U200 | 2018.3 | Ubuntu 18.04
alveo-u200-2019-1-centos      | Alveo U200 | 2019.1 | CentOS
alveo-u200-2019-1-ubuntu-1604 | Alveo U200 | 2019.1 | Ubuntu 16.04
alveo-u200-2019-1-ubuntu-1804 | Alveo U200 | 2019.1 | Ubuntu 18.04
alveo-u250-201830-centos      | Alveo U250 | 2018.3 | CentOS
alveo-u250-201830-ubuntu-1604 | Alveo U250 | 2018.3 | Ubuntu 16.04
alveo-u250-201830-ubuntu-1804 | Alveo U250 | 2018.3 | Ubuntu 18.04
alveo-u250-2019-1-centos      | Alveo U250 | 2019.1 | CentOS
alveo-u250-2019-1-ubuntu-1604 | Alveo U250 | 2019.1 | Ubuntu 16.04
alveo-u250-2019-1-ubuntu-1804 | Alveo U250 | 2019.1 | Ubuntu 18.04
alveo-u280-2019-1-centos      | Alveo U280 | 2019.1 | CentOS
alveo-u280-2019-1-ubuntu-1604 | Alveo U280 | 2019.1 | Ubuntu 16.04
alveo-u280-2019-1-ubuntu-1804 | Alveo U280 | 2019.1 | Ubuntu 18.04

## Isolated Runtime Evniroment

Docker is a set of platform-as-a-service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Inside container, you can have an isolated runtime evniorment with pre-installed XRT(Xilinx Runtime) and dependencies. 
> However, the container cannot access host kernel. Therefore you need install same version XRT on host as driver and use XRT inside container as runtime. And the FPGA should be flashed with specified Shell. You can find all installation packages from [Xilinx Product Page](https://www.xilinx.com/products/boards-and-kits/alveo.html) or installing with this project. See **`Install XRT and Shell`**. 
![Runtime](doc/runtime.png)

### Runtime Example
1. Clone repository from Xilinx GitHub
```
user@machine:~$ git clone https://github.com/Xilinx/software_shell_deployment.git
```
2. Go to software_shell_deployment directory
```
user@machine:~$ cd software_shell_deployment
```

3. Run run.sh with corresponding arguments: platform, xrt version and os version
```
#  ./run.sh     --platform <platform> --version <version> --os-version <os-version>
#  ./run.sh      -p        <platform>  -v       <version>  -o          <os-version>
#  <platform>     : alveo-u200 / alveo-u250 / alveo-u280
#  <version>      : 2018.3 / 2019.1
#  <os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos
user@machine:~/software_shell_deployment$ ./run.sh -p alveo-u200 -v 2019.1 -o ubuntu-18.04
```

4. Inside docker container, run `list` or `dmatest` with `xbutil` for listing cards or testing dma. Or copy your own application and xclbin files to container and run for test. 
```
root@fc33db3f6ed6:/$ /opt/xilinx/xrt/bin/xbutil list

root@fc33db3f6ed6:/$ /opt/xilinx/xrt/bin/xbutil dmatest
```

## Install XRT and Shell

This project can help you to install XRT and Shell on your host with these unified docker images. You do NOT need to worry about mis-match XRT and Shell and installing XRT and flashing card with one command by using install.sh and providing three parameters: platform, version and OS version. Besides, you can decide to install XRT only or flash Shell only or both together. But at least one option and please be aware that XRT should be installed before installing Shell. 

The figure shows how installing XRT and Shell is been done. With the specified platform, version and OS version, we can copy correspoding XRT and Shell installation packages from docker container to host /tmp directory. 
![Install XRT and Shell](doc/install_xrt_shell.png)

### Installation Example
1. Deployment script must be run as root
```
user@machine:~$ sudo -i
```
2. Clone repository from Xilinx GitHub
```
root@machine:~$ git clone https://github.com/Xilinx/software_shell_deployment.git
```

3. Go to software_shell_deployment directory
```
root@machine:~$ cd software_shell_deployment
```

4. Acoording to demand choosing depolyment shell with corresponding arguments: platform, xrt version and os version
   With --install-xrt and --install-shell to choose install XRT or Shell. You can install both together. But at leat choose one option. 
```
#  ./install.sh     --install-xrt --install-shell --platform <platform> --version <version> --os-version <os-version>
#  ./install.sh     -x              -s             -p        <platform>  -v       <version>  -o          <os-version>
#  <platform>     : alveo-u200 / alveo-u250 / alveo-u280
#  <version>      : 2018.3 / 2019.1
#  <os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos
root@machine:~$ ./deploy_xrt_shell.sh -p alveo-u200 -v 2019.1 -o ubuntu-18.04
```

5. Wait until installation completed. During the period you may need press [Y] to continue. Please Note: If you choose flashing FPGA, you need to cold reboot local machine to load the new image on FPGA.

## Base Docker Images
All the docker images provided by this project can be used as base images for building your own docker applications because they all have XRT and dependencies installed. Here is an simple example how to create Dockerfile to build.

```
# Choose one of images as base image based on platform, version and OS version
FROM xilinx/xsds:alveo-u280-2019-1-ubuntu-1804
```