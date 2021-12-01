#!/bin/bash

sensor=$(cat /sys/class/hwmon/hwmon2/temp1_input)

out=$(bc <<< 'scale=1; '$sensor'/1000')

echo "﨎 "$out"°C"
