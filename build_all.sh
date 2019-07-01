#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

cd Dockerfiles
for path in $(find . -name build.sh )  ; do cd $(dirname "$path"); ./build.sh; cd -; done