#!/bin/sh

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1		& # Gnome Polkit
nitrogen --restore																					& # Wallpaper
picom																												& # Compositor
setxkbmap -option compose:ralt	 														& # Compose Key
xsetroot -cursor_name left_ptr															& # Cursor
#~/Scripts/glava.sh                                          & # Glava
alsactl --file ~/.config/asound.state restore								& # Restore Alsa
~/Scripts/apod.sh																						& # Astronomic Pic of the Day
joplin sync && joplin ls > /dev/shm/todo										& # Synchronize Joplin and ToDo file
/usr/lib/xfce4/notifyd/xfce4-notifyd												& # Notification Daemon
