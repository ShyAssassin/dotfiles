#!/bin/sh

sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal-lxqt
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal-kde
killall -e xdg-desktop-portal
sleep 1

/usr/lib/xdg-desktop-portal-hyprland & sleep 1
/usr/lib/xdg-desktop-portal-gtk & sleep 1
/usr/lib/xdg-desktop-portal & sleep 1
