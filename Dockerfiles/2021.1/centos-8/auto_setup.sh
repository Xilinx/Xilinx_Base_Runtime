#!/bin/bash
wrapper_debug=1

#function to compare two versions
# 0 - =
# 1 - >
# 2 - <
vercomp () {
    if [[ $1 == $2 ]]
        then
            return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
            then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
            then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
            then
            return 2
        fi
    done
    return 0
}

#user input big release version
processEnvBig () {
    USER_SETTING_tmp=
    USER_SETTING_Version=
    for ((i=0; i<${#BIG_Release[@]}; i++))
    do
        if [ "${BIG_Release[i]}" == "$XRT_VERSION" ] ; then
        if [ -z $USER_SETTING_tmp ]; then
            USER_SETTING_tmp=${SMALL_Release[i]}
            USER_SETTING_Version=${Release[i]}
        else
            vercomp ${SMALL_Release[i]} $USER_SETTING_tmp
            if [ "$?" == "1" ]; then
            USER_SETTING_tmp=${SMALL_Release[i]}
            USER_SETTING_Version=${Release[i]}
            fi
        fi
        fi
    done
    if [ ! -z $USER_SETTING_tmp ]; then
        XILINX_XRT=/opt/xilinx/xrt_versions/xrt_${USER_SETTING_Version}
    fi
}

#user input small release version
processEnvSmall () {
    USER_SETTING_SMALLVersion=
    for ((i=0; i<${#SMALL_Release[@]}; i++))
    do
        if [ "${SMALL_Release[i]}" = "$XRT_VERSION" ] ; then
        USER_SETTING_SMALLVersion=$i
        break
        fi
    done
    if [ ! -z $USER_SETTING_SMALLVersion ]; then
        XILINX_XRT=/opt/xilinx/xrt_versions/xrt_${Release[$USER_SETTING_SMALLVersion]}
    fi
}

showRels () {
  if [ -z "$DEFAULT_Release" ];then
    rels=
    vers=
    for d in `ls -d /opt/xilinx/xrt_versions/xrt_*`; do
        rel=${d#/opt/xilinx/xrt_versions/xrt_}
        ver=$(grep BUILD_VERSION $d/version.json | cut -d'"' -f4 | head -n 1)
        rels="${rels}${rels:+|}${rel}"
        vers="${vers}${vers:+, }${rel} (${ver})"
    done
    echo "WARNING: Cannot find Host XRT Version: ${driver_ver}"
    echo "WARNING: Found ${vers} in container"
    echo "WARNING: Please install one of the supported versions XRT listed above on the host machine or set the environment variable XRT_VERSION=${rels} to force run."
  fi
}

processEnvAuto () {
    #get all the supported version from the xrt folders

    DEFAULT_BIG_Release=
    DEFAULT_SMALL_Release=
    DEFAULT_Release=
    NEAREST_GT_Release=
    NEAREST_GT_ReleaseInd=
    NEAREST_LE_Release=
    NEAREST_LE_ReleaseInd=

    #choose the completely matched xrt
    for d in `ls -d /opt/xilinx/xrt_versions/xrt_*`; do
        m=$(grep "\"BUILD_VERSION\" *: *\"${driver_ver}\"" ${d}/version.json)
        if [ -n "$m" ]; then
        XILINX_XRT=$d
        DEFAULT_Release=${d#/opt/xilinx/xrt_versions/xrt_}
        DEFAULT_BIG_Release=${DEFAULT_Release:0:6}
        DEFAULT_SMALL_Release=${DEFAULT_Release:7}
        break
        fi
    done
    # warning when no mathed xrt
    showRels

    #if no matched xrt, choose nearest new version -> nearest old version
    if [ -z $XILINX_XRT ]
    then
        for ((i=0; i<${index}; i++))
        do
            vercomp ${driver_ver} ${SMALL_Release[i]}
            comp=$?
        if [ "$comp" == "2" ]
        then
            if [ -z $NEAREST_GT_Release ]
            then
                NEAREST_GT_Release=${SMALL_Release[i]}
                NEAREST_GT_ReleaseInd=$i
            else
                vercomp $NEAREST_GT_Release ${SMALL_Release[i]}
            if [ "$?" == "1" ]
            then
                NEAREST_GT_Release=${SMALL_Release[i]}
                NEAREST_GT_ReleaseInd=$i
            fi
            fi
        elif [ "$comp" == "1" ]
        then
            if [ -z $NEAREST_LE_Release ]
            then
                NEAREST_LE_Release=${SMALL_Release[i]}
                NEAREST_LE_ReleaseInd=$i
            else
            vercomp $NEAREST_LE_Release ${SMALL_Release[i]}
            if [ "$?" == "2" ]
            then
                NEAREST_LE_Release=${SMALL_Release[i]}
                NEAREST_LE_ReleaseInd=$i
            fi
            fi
        fi
        done
        if [ ! -z  $NEAREST_GT_Release ]
        then
            XILINX_XRT=/opt/xilinx/xrt_versions/xrt_${Release[$NEAREST_GT_ReleaseInd]}
        elif [ ! -z $NEAREST_LE_Release ]
        then
            XILINX_XRT=/opt/xilinx/xrt_versions/xrt_${Release[$NEAREST_LE_ReleaseInd]}
        fi
    fi
}

#check the sysfile to get driver version
if [ ! -f /sys/bus/pci/drivers/xocl/module/version ]; then
    echo "ERROR: xocl driver cannot be accessed in container! Abort!"
    exit 1
fi

driver_ver=$(cat /sys/bus/pci/drivers/xocl/module/version | cut -d, -f1)
if [ $wrapper_debug -ne 0 ]; then
    echo "INFO: XRT version on host machine is ${driver_ver}"
fi

BIG_Release=()
SMALL_Release=()
Release=()
let index=0 
for d in `ls -d /opt/xilinx/xrt_versions/xrt_*`; do
    rel=${d#/opt/xilinx/xrt_versions/xrt_}
    BIG_Release[$index]=${rel:0:6}
    SMALL_Release[index]=${rel:7}
    Release[$index]=${rel}
    ((index++))
done

XILINX_XRT=
if [ -z "$XRT_VERSION" ]; then
    # when no mathing, raise warning
    echo "INFO: No match found, will automatically source XRT Version ${XILINX_XRT}"
    XRT_VERSION=${driver_ver}
    processEnvAuto
else
    # if the setting from env
    echo "INFO: Match found, will source XRT Version ${XRT_VERSION}"
    if [[ " ${Release[@]} " =~ " ${XRT_VERSION} " ]];then
        XILINX_XRT=/opt/xilinx/xrt_versions/xrt_${XRT_VERSION}
    else
        processEnvBig
        if [ -z ${XILINX_XRT} ];then
            processEnvSmall
        fi
        if [ -z ${XILINX_XRT} ];then
            echo "INFO: Match found, will automatically source XRT Version ${XILINX_XRT}"
            processEnvAuto
        fi
    fi
fi
#set environment
echo "source ${XILINX_XRT}/setup.sh"
source ${XILINX_XRT}/setup.sh 1>/dev/null
if [ $wrapper_debug -ne 0 ]; then
    echo "XILINX_XRT=${XILINX_XRT}"
    echo "PATH=${PATH}"
    echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
fi
if [ ${driver_ver} != ${XRT_VERSION} ]; then
    export INTERNAL_BUILD=1
    echo "INFO: Version mismatch, INTERNAL_BUILD set to 1"
fi
