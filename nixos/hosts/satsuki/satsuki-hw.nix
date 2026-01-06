{config, lib, pkgs, modulesPath, ...}: {
  imports =[(modulesPath + "/installer/scan/not-detected.nix")];

  networking.useDHCP = lib.mkDefault true;
  swapDevices = [ { device = "/swap/swapfile"; } ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    extraModulePackages = [];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages;
    initrd.availableKernelModules = ["ehci_pci" "ahci" "megaraid_sas" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };

  fileSystems."/home" = {
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };

  fileSystems."/nix" = {
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };


  fileSystems."/swap" = {
    fsType = "btrfs";
    options = ["subvol=@swap" "noatime"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };


  fileSystems."/var/log" = {
    fsType = "btrfs";
    options = ["subvol=@log" "compress=zstd"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };

  fileSystems."/snapshots" = {
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress=zstd"];
    device = "/dev/disk/by-uuid/94d2a8ab-5ef4-4b0b-9b77-53b12ed51f3d";
  };
}
