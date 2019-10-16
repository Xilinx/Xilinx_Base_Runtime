# Software and SHELL deployment docker solution
## Description
This project provides unified docker images for several purposes: 

* [Isolated Runtime Enviorment](#isolated-runtime-enviorment)
* [Install XRT and Shell on host](#install-xrt-and-shell)
* [As base image for docker application](#base-docker-images)

For more docker information, please refer [Docker Documentation](https://docs.docker.com). 

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

## Isolated Runtime Enviorment

Docker is a set of platform-as-a-service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Inside container, you can have an isolated runtime enviorment with pre-installed XRT(Xilinx Runtime) and dependencies. 
> However, the container cannot access host kernel. Therefore you need install same version XRT on host as driver and use XRT inside container as runtime. And the FPGA should be flashed with specified Shell. You can find all installation packages from [Xilinx Product Page](https://www.xilinx.com/products/boards-and-kits/alveo.html) or installing with this project. See [**`Install XRT and Shell`**](#install-xrt-and-shell). 

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

This project will help to install XRT and Shell on the host machine with the above unified docker images. A single command (install.sh) with three parameters: platform, XRT and OS version can be used to install the XRT, Shell as well as Flash the card.  Besides, you can even decide whether to install XRT only/flash card only/do both. 

> Note: XRT should be installed before installing Shell.
 

The figure shows how installing XRT and Shell is been done. With the specified platform, version and OS version, the project copies correspoding XRT and Shell installation packages from docker container to host /tmp directory. Then it installs XRT and Shell and flashes the card automatically.  

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

4. .  According to demand, choose deployment shell with corresponding parameters: platform, XRT version and OS version. At least one of the two parameters listed below maybe specified:
  * --install-xrt (-x)    is the parameter for XRT installation option
  * --install-shell (-s)  is the parameter for Shell installation option

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
All the docker images provided by this project can be used as base images for building your own docker applications because they all have XRT and dependencies installed. Here is an simple example of Dockerfile.

```
# Choose one of images as base image based on platform, version and OS version
FROM xilinx/xsds:alveo-u280-2019-1-ubuntu-1804

# Configure enviroment what your application needs, for example
apt-get install [dependencies]

# Copy your application and xclbin files
COPY [application_file] [path_of_application_file]
COPY [xclbin_file] [path_of_xclbin_file]
```

Then you can use `docker build -f [Dockerfile]` to build your own docker application. 