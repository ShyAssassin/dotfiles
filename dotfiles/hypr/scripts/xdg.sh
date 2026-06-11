#!/bin/sh

sleep 1
    killall xdg-desktop-portal-hyprland
    killall xdg-desktop-portal-gnome
    killall xdg-desktop-portal-lxqt
    killall xdg-desktop-portal-wlr
    killall xdg-desktop-portal-gtk
    killall xdg-desktop-portal-kde
    killall xdg-desktop-portal
    # NixOS
    killall .xdg-desktop-portal-hyprland
    killall .xdg-desktop-portal-gnome
    killall .xdg-desktop-portal-lxqt
    killall .xdg-desktop-portal-wlr
    killall .xdg-desktop-portal-gtk
    killall .xdg-desktop-portal-kde
    killall .xdg-desktop-portal
sleep 1

/usr/lib/xdg-desktop-portal-hyprland & sleep 1
/usr/lib/xdg-desktop-portal-gtk & sleep 1
/usr/lib/xdg-desktop-portal & sleep 1
