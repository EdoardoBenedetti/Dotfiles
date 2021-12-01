#!/bin/bash
if [ -f "/dev/shm/pomodoro" ];then
				echo " $(cat /dev/shm/pomodoro)"
else
				echo ""
fi
