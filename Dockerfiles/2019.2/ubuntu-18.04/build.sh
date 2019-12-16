#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

TAG="xilinx/xilinx_runtime_base:alveo-2019-2-ubuntu-1804"

while true
do
case "$1" in
	-t|--tag        ) TAG="$2"     ; shift 2 ;;
*) break ;;
esac
done

docker build -t $TAG .

docker push $TAG
