#!/bin/bash

# Variables
status=Work

workTime=25 #25 mins
restTime=5 #5 mins
extraTime=1 #1 min

#Functions
timer () {
				min=$2
				sec=0
				while [ $min -ge 0 ]; do
								while [ $sec -ge 0 ]; do
												if [ $sec -ge 10 ]; then
															time="$min:$sec"
												else
															time="$min:0$sec"
												fi
												echo -ne "$1: $time\n" > /dev/shm/pomodoro
												let "sec=sec-1"
												sleep 1
								done
								sec=59
								let "min=min-1"
				done	
				#yes | pv -SL1 -F "$1 left: %e" -s $2 > /dev/null
}

sendnotification () {
				not_res=$(dunstify "Your $1 timer has finished" -A "next,Continue" -A "one,Add one minute" -A "end,Finish" -t 15000)
}

action () {
				if [ $not_res == "one" ]; then
								wcs "Extra" "$extraTime" "extra"
				elif [ $not_res == "end" ]; then
								prockill
				else
								status_next
				fi
}

wcs () {
				timer "$1" "$2"
				beep
				sendnotification "$3"
				action
}

status_next () {
				if [ $status == "Work" ]; then
								status=Rest
				else
								status=Work
				fi
}


# Main
main () {
				while :; do
								if [ $status == "Work" ]; then
												wcs "Work" "$workTime" "work"
								elif [ $status == "Rest" ]; then
												wcs "Rest" "$restTime" "rest"
								else
												break
								fi
				done
}

prockill () {
				rm /dev/shm/pomodoro
				kill $(ps aux | grep /bin/bash | grep pomodoro.sh | awk '{print $2}' | head -n 1)
				rm /dev/shm/pomodoro

}
# Execution
if [ -f "/dev/shm/pomodoro" ]; then
				prockill
else
				main
fi
