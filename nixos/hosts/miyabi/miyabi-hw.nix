{config, lib, pkgs, modulesPath, ...}: {
  imports =[(modulesPath + "/installer/scan/not-detected.nix")];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  swapDevices = [ { device = "/swap/swapfile"; size = 128*1024; } ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    initrd.kernelModules = [ ];
    kernelModules = ["kvm-amd"];
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages;
    kernelParams = ["amd_iommu=on" "iommu=pt"];
    blacklistedKernelModules = ["hid-thrustmaster"];
    extraModulePackages = with config.boot.kernelPackages; [hid-tmff2];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  };

  services.udev.extraRules = ''
    # Bigscreen Beyond
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", GROUP="wheel"
    # Bigscreen Beyond Firmware Mode
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", GROUP="wheel"
    # Bigscreen Beyond Error Mode
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="1001", MODE="0660", GROUP="wheel"

    # Bigscreen Bigeye
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", GROUP="wheel"
    # Bigscreen Bigeye DFU Mode
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0282", MODE="0660", GROUP="wheel"
  '';

  hardware.nvidia = {
    open = true;
    enable = true;
    nvidiaSettings = false;
    enableCudaSupport = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # Bigscreen beyond fixes https://github.com/NVIDIA/open-gpu-kernel-modules/issues/1039
    package = config.boot.kernelPackages.nvidiaPackages.stable // {
      open = config.boot.kernelPackages.nvidiaPackages.stable.open.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          (builtins.fetchurl {
            sha256 = "sha256-9lYaXPvzuxbMD07MBf3mCcVmj4T04eTcbih5li5/7Kg=";
            url = "https://raw.githubusercontent.com/triple-groove/nvidia-bsb-dsc-fix/main/0001-fix-dsc-correct-RC-parameter-tables-to-match-VESA-DS.patch";
          })
          (builtins.fetchurl {
            sha256 = "sha256-LbqyuQzQ8EZ7nhhiiWTS6UrWvuKXvSXVHHB0S0G44qM=";
            url = "https://raw.githubusercontent.com/triple-groove/nvidia-bsb-dsc-fix/main/0002-fix-dsc-use-bits_per_component-for-flatnessDetThresh.patch";
          })
          (builtins.fetchurl {
            sha256 = "sha256-F7Wp09FL2qwMs7BDIvPguegZDI3N+Avx23JRX12sCWA=";
            url = "https://raw.githubusercontent.com/triple-groove/nvidia-bsb-dsc-fix/main/0003-fix-dp-add-Bigscreen-Beyond-VR-headset-to-WAR-databa.patch";
          })
        ];
      });
    };
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "595.71.05";
    #   openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
    #   sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    #   settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";
    #   persistencedSha256 = "sha256-Z/6IvEEa/XfZ5F5qoSIPvXJLGtscYVqjFxHZaN/M2Ts=";
    # };
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
    device = "/dev/disk/by-uuid/12CE-A600";
  };

  fileSystems."/" ={
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/home" = {
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/nix" = {
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/var/log" = {
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=@varlog" "compress=zstd"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/snapshots" = {
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress=zstd"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/swap" = {
    fsType = "btrfs";
    options = ["subvol=@swapfile" "noatime"];
    device = "/dev/disk/by-uuid/63ec8a18-95d0-4284-94ad-f3904583e87a";
  };

  fileSystems."/mnt/Games" = {
    fsType = "ext4";
    options = ["rw" "nofail" "errors=remount-ro"];
    device = "/dev/disk/by-uuid/8aa2a098-44bc-4b59-acdd-0fcc06f45539";
  };
}
