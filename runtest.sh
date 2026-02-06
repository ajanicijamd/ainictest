#!/usr/bin/env bash

. ./setenv.sh

export URL1=https://github.com/ROCm/rocprofiler-systems/releases/download/rocm-6.4.1/rocprofiler-systems-1.0.1-ubuntu-22.04-ROCm-60400-PAPI-OMPT-Python3.sh
export URL2=https://github.com/ROCm/rocprofiler-systems/releases/download/rocm-6.4.3/rocprofiler-systems-1.0.2-rhel-9.4-PAPI-OMPT-Python3.sh

export BINDIR=$ROCM_PATH/bin

rm -rf rocprofsys-tests-output

# Commands for different tests
##############################

# No NIC
# echo Test No NIC
# $BINDIR/rocprof-sys-sample --gpus=0,1 --device -- wget -O /dev/null --no-check-certificate $URL1 $URL2

# Wrong NIC
# echo Test Wrong NIC
# $BINDIR/rocprof-sys-sample --gpus=0,1 --ainics=wrongnic --device -- wget -O /dev/null --no-check-certificate $URL1 $URL2

# Right NIC
# echo Test one NIC
# $BINDIR/rocprof-sys-sample --gpus=0,1 --ainics=enp229s0 --device -- wget -O /dev/null --no-check-certificate $URL1 $URL2

# List of NICs: all
# echo List of NICs: all
# $BINDIR/rocprof-sys-sample --gpus=0,1 --ainics=all --device -- wget -O /dev/null --no-check-certificate $URL1 $U>

# List of NICs: none
# echo List of NICs: none
# $BINDIR/rocprof-sys-sample --gpus=0,1 --ainics=none --device -- wget -O /dev/null --no-check-certificate $URL1 $U>

# Repeated NIC
# echo List of NICs with a duplicate and wrong NIC
$BINDIR/rocprof-sys-sample --gpus=0,1 --ainics="enp229s0,wrongnic,enp229s0" \
  --device -- wget -O /dev/null --no-check-certificate $URL1 $URL2
