#!/bin/bash

########################
# Author: Vidit
# Date: 13-01-26
#
# This script outputs the health of a node
#
# Version: V1
########################

#set -x # Uncomment for Debug Mode
set -e # Exit the script when error occurs
set -o pipefail # Pipefail
# set -exo pipefail


echo "=====Disk Space====="
df -h #gives disk space

echo "=====Memory====="
free -g #gives memory

echo "=====CPU====="
nproc #gives resources

echo "=====Running Processes====="
ps -ef | awk -F" " '{print $2, $8}'
