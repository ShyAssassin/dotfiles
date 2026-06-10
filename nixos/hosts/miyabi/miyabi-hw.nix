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

  hardware.nvidia = {
    open = true;
    enable = true;
    nvidiaSettings = false;
    enableCudaSupport = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.71.05";
      openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
      sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
      settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";
      persistencedSha256 = "sha256-Z/6IvEEa/XfZ5F5qoSIPvXJLGtscYVqjFxHZaN/M2Ts=";
    };
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
    fsType = "ntfs";
    options = ["rw" "uid=1000" "nofail"];
    device = "/dev/disk/by-uuid/DA3C5AC23C5A98F9";
  };
}
