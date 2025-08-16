#!/run/current-system/sw/bin/bash

exec 19>/home/assassin/Desktop/startlogfile
BASH_XTRACEFD=19
set -x

readonly GUEST_NAME="$1"
readonly HOOK_NAME="$2"
readonly STATE_NAME="$3"

if [[ "$GUEST_NAME" != "win11" ]]; then
  exit 0
fi

if [[ "$HOOK_NAME" == "prepare" && "$STATE_NAME" == "begin" ]]; then
  echo "Unbinding GPU from host..."

  hyprctl dispatch exit
  systemctl stop display-manager
  ~/.config/hypr/scripts/shutdown.sh
  # Fucking KDE not stopping properly...
  systemctl --user -M assassin@ stop plasma*

  sleep 5

  echo 0 > /sys/class/vtconsole/vtcon0/bind
  echo 0 > /sys/class/vtconsole/vtcon1/bind
  echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

  sleep 5

  # Unload Nvidia kernel modules
  modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

  # Unbind GPU
  virsh nodedev-detach pci_0000_0c_00_0
  virsh nodedev-detach pci_0000_0c_00_1

  # Unbind USB controllers
  virsh nodedev-detach pci_0000_05_00_0
  virsh nodedev-detach pci_0000_09_00_0
  virsh nodedev-detach pci_0000_09_00_1
  virsh nodedev-detach pci_0000_09_00_3

  # Load vfio kernel modules
  modprobe vfio_pci

  # Set CPU governor to performance
  for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > $file
  done
  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
elif [[ "$HOOK_NAME" == "release" && "$STATE_NAME" == "end" ]]; then
  echo "Rebinding GPU to host..."

  # Unload vfio kernel modules
  modprobe -r vfio_pci

  # Rebind GPU
  virsh nodedev-reattach pci_0000_0c_00_0
  virsh nodedev-reattach pci_0000_0c_00_1

  # Rebind USB controllers
  virsh nodedev-reattach pci_0000_05_00_0
  virsh nodedev-reattach pci_0000_09_00_0
  virsh nodedev-reattach pci_0000_09_00_1
  virsh nodedev-reattach pci_0000_09_00_3

  # Reload Nvidia kernel modules
  modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

  echo 1 > /sys/class/vtconsole/vtcon0/bind
  echo 1 > /sys/class/vtconsole/vtcon1/bind
  echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

  # Set CPU governor to powersave
  for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "powersave" > $file
  done
  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  systemctl start display-manager
fi
