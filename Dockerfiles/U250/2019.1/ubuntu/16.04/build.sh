#!/usr/bin/env bash
#
# (C) Copyright 2019, Xilinx, Inc.
#
#!/usr/bin/env bash

TAG="xdock:5000/xsds:alveo-u250-2019-1-ubuntu-1604"

while true
do
case "$1" in
	-t|--tag        ) TAG="$2"     ; shift 2 ;;
*) break ;;
esac
done

docker build -t $TAG .

docker push $TAG