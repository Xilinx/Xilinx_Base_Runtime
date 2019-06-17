#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

cd Dockerfiles
for path in $(dirname "$(find . -name build.sh )")  ; do cd $path; build.sh; cd -; done