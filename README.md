# Software and SHELL deployment docker solution
## Description
Software and SHELL deployment docker solution provides unified docker images in specific XRT, Shell and OS version for isolated runtime evniroment and depolyment. 
## Available Docker Images
![Docker Images](doc/docker_images.png)
## Runtime Example
Use run.sh for runtime uages. This provides an isolated runtime enviroment inside docker container. 
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

4. Inside docker container, run `list` or `dmatest` with `xbutil` for listing cards or testing dma
```
root@fc33db3f6ed6:/$ /opt/xilinx/xrt/bin/xbutil list

root@fc33db3f6ed6:/$ /opt/xilinx/xrt/bin/xbutil dmatest
```
## Depolyment Example
Use install.sh for depolyment usage. This installs XRT or Shell on local machine with unified docker images. 
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
#	 ./deploy.sh     --install-xrt --install-shell --platform <platform> --version <version> --os-version <os-version>
#	 ./deploy.sh     -x              -s            -p        <platform>  -v       <version>  -o          <os-version>
#	 <platform>     : alveo-u200 / alveo-u250 / alveo-u280
#	 <version>      : 2018.3 / 2019.1
#	 <os-version>   : ubuntu-18.04 / ubuntu-16.04 / centos
root@machine:~$ ./deploy_xrt_shell.sh -p alveo-u200 -v 2019.1 -o ubuntu-18.04
```

5. Wait until installation completed. During the period you may need press [Y] to continue. Please Note: If you choose flashing FPGA, you need to cold reboot local machine to load the new image on FPGA.
