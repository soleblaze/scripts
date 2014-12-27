#!/bin/bash

# Disk Space function
diskusage() {
    drivepath=$1
    drivename=$2
    rawspace=$(btrfs fi df -b $drivepath | sed -e 's/.*total=\([0-9]*\),.*/\1/' | tr "\n" " " | sed -e 's/\ $/\n/' -e 's/\ /\ +\ /g' | bc)
    freespace=$(echo $rawspace | awk '{printf "%.2f\n", $1/1024/1024/1024}')
    totalspace=$(df $drivepath | tail -n1 | awk '{printf "%.2f\n", $2/1024/1024}')
    percentspace=$(echo 100 - $freespace/$totalspace\*100 | bc -l)
    printf "$drivename: %.2f/%.2fGiB (%.1f%% Free)\n" $freespace $totalspace $percentspace
}

# Date
echo "Date: $(date)"
# CPU Usage
mpstat | tail -n1 | awk '{printf "CPU: %.2f%%\n", $4}'
# Load Average
uptime | awk '{print "Load Average: "$8" "$9" "$10}'
# CPU Temp
cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "CPU Temp: %2dC\n", $1/1000}'
# CPU Freq Info
cpufreq="/sys/devices/system/cpu/cpu0/cpufreq"
curfreq=$(cat $cpufreq/scaling_cur_freq)
maxfreq=$(cat $cpufreq/scaling_max_freq)
echo $curfreq $maxfreq | awk '{printf "CPU Frequency: %.2fGHz (Max %.2fGHz)\n", $1/1000000, $2/1000000}'
echo "CPU Governor: $(cat $cpufreq/scaling_governor)"

# Memory Usage⎈
free -m | grep Mem | awk '{printf "Memory: %.1f/%.1fGiB (%.1f%% Free)\n", $3/1024, $2/1024, 100-$3/$2*100}'


# Display Disk space
diskusage "/home" "Home"
diskusage "/" "Root"

# Wifi
if [ "$(nmcli -t --fields state,connection dev status | grep connected)" ]; then
    ssid=$(nmcli -t --fields state,connection dev status | grep connected | cut -d":" -f2)
    strength=$(nmcli -t --fields general.state d show wlp3s0 | cut -d":" -f2 | cut -d" " -f1)
    echo "Wireless: $ssid ($strength%)"
else
    echo "Wireless: N/A"
fi

# Battery
bat=BAT0
sysbat=/sys/class/power_supply/$bat
batuevent=$(cat $sysbat/uevent)
batpercent=$(cat $sysbat/capacity)
batenergy=$(cat $sysbat/energy_now)
batdischarge=$(cat /sys/class/power_supply/BAT0/power_now)
bathours=$(echo $batenergy/$batdischarge | bc)

echo "Battery Status: $(cat $sysbat/status)"
echo $batenergy $batdischarge $bathours |  awk '{printf "Time Left: %.0f:%.0f\n", $3, ($1/$2-$3)*60}'


# Power Usage
echo $batdischarge | awk '{printf "Power Usage: %.2fW\n", $1/1000000}'
