#!/bin/bash

title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
				org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
				string:'Metadata' | awk -F '"' 'BEGIN {RS=" entry"}; /"xesam:artist"/ {a = $4} \
				/"xesam:title"/ {b = $4} END {print a " - " b}')

if [ ${#title} -ge 40 ]; then
				echo ${title:0:39}"…"
else
				echo $title
fi
