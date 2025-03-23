#!/bin/sh
unset GTK_THEME
unset XCURSOR_THEME
unset NIXOS_OZONE_WL
unset QT_QPA_PLATFORM
unset XDG_SESSION_TYPE
unset XDG_CURRENT_DESKTOP
unset XDG_SESSION_DESKTOP
unset QT_QPA_PLATFORMTHEME
unset WLR_NO_HARDWARE_CURSORS

killall hypridle
killall .hypridle
killall xdg-desktop-portal
killall .xdg-desktop-portal
killall xdg-desktop-portal-gtk
killall .xdg-desktop-portal-gtk
killall xdg-desktop-portal-hyprland
killall .xdg-desktop-portal-hyprland

systemctl --user stop arRPC
systemctl --user stop hyprpolkitagent

if [ -n "$(pgrep Hyprland)" ]; then
    hyprctl dispatch exit
fi
