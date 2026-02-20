#!/bin/bash

#############################################
# Author: Vidit                             #
# Date: 13-01-26                            #
# Description: Enhanced Node Health Monitor #
# Version: V2                               #
#############################################

# Fail fast, fail early
set -euo pipefail

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Node Health Report: $(hostname) ===${NC}"
echo "Date: $(date)"
echo "Uptime: $(uptime -p)"

echo -e "\n${GREEN}--- Disk Space Usage ---${NC}"
# Showing only physical disks, excluding temp filesystems
df -h | grep '^/dev/' || echo "No physical disks found."

echo -e "\n${GREEN}--- Memory Usage (GB) ---${NC}"
free -g | awk 'NR==1{print "Type\tTotal\tUsed\tFree"} NR==2{print "Mem:\t"$2"G\t"$3"G\t"$4"G"} NR==3{print "Swap:\t"$2"G\t"$3"G\t"$4"G"}'

echo -e "\n${GREEN}--- CPU Load & Cores ---${NC}"
echo "CPU Cores: $(nproc)"
echo "Load Average (1m, 5m, 15m): $(uptime | awk -F'load average:' '{ print $2 }')"

echo -e "\n${GREEN}--- Top 5 Resource-Hungry Processes ---${NC}"
# PID, CPU%, MEM%, Command - sorted by CPU usage
ps -eo pid,ppid,pcpu,pmem,comm --sort=-pcpu | head -n 6

echo -e "\n${GREEN}--- Network Status ---${NC}"
# Check if internet is reachable (optional but helpful)
ping -c 1 google.com &> /dev/null && echo "Internet: Connected" || echo -e "Internet: ${RED}Disconnected${NC}"

echo -e "\n${GREEN}========================================${NC}"
