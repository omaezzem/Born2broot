#!/bin/bash

architecture=$(uname -a)
ncpu=$(grep "physical id" /proc/cpuinfo | wc -l)
ncpuv=$(grep "processor" /proc/cpuinfo  | wc -l)
ram_t=$(free --mega | awk '/Mem:/ {printf "%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100}')
disk_t=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3; total += $2} END {printf("%d/%.0fGb (%d%%)\n", used, total/1024, used/total*100)}')
cucpu=$( mpstat| grep all | awk '{printf "%.2f%%",100 - $13}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4 " " $5}')
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
tcpc=$(ss -t | grep ESTAB | wc -l)
userslogs=$(users| tr " " "\n" | uniq | wc -l)
mac=$(hostname -I)
mac=$(echo "$(hostname -I | awk '{print $1}') ($(ip link | grep 'link/ether' | awk '{print $2}'))")
cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "     #Architecture:        $architecture
    #CPU Physical:        $ncpu
    #vCPU:                $ncpuv
    #Memory Usage:        $ram_t
    #Disk Usage:          $disk_t
    #CPU Load:            $cucpu
    #Last Boot:           $lb
    #LVM Use:             $lvm
    #TCP Connections:     $tcpc ESTABLISHED
    #User Log:            $userslogs
    #Network: IP          $mac
    #Sudo Commands Used:  $cmd cmd
"
