#!/bin/sh

unset XDG_SESSION_TYPE
unset XDG_CURRENT_DESKTOP
unset XDG_SESSION_DESKTOP
unset QT_QPA_PLATFORMTHEME
unset WLR_NO_HARDWARE_CURSORS

killall hypridle & sleep 1
killall xdg-desktop-portal & sleep 1
killall xdg-desktop-portal-gtk & sleep 1
killall xdg-desktop-portal-hyprland & sleep 1
systemctl --user stop hyprpolkitagent & sleep 1
