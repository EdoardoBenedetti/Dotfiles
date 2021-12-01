#!/bin/bash

brightness=$(xrandr --verbose | grep Brightness | awk '{print $NF}' | sed 2d)

for i in $(xrandr --listactivemonitors | awk '{print $NF}' | sed 1d)
do
				
				if [ $1 == 'up' ]
				then
								new=$(bc <<< "$brightness + 0.1")
				else
								new=$(bc <<< "$brightness - 0.1")
				fi
				
				xrandr --output $i --brightness $new
done
