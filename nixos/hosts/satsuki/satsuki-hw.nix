{config, lib, pkgs, modulesPath, ...}: {
  imports =[(modulesPath + "/installer/scan/not-detected.nix")];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    extraModulePackages = [];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    supportedFilesystems = ["zfs"];
    initrd.availableKernelModules = [ "ehci_pci" "ahci" "mpt3sas" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  };

  fileSystems."/" = {
    fsType = "zfs";
    device = "rpool/root";
  };

  fileSystems."/home" = {
    fsType = "zfs";
    device = "rpool/home";
  };

  fileSystems."/nix" = {
    fsType = "zfs";
    device = "rpool/nix";
  };

  fileSystems."/var/log" = {
    fsType = "zfs";
    device = "rpool/varlog";
  };

  fileSystems."/boot/usb" = {
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
    device = "/dev/disk/by-uuid/4E87-835B";
  };

  fileSystems."/boot/disk1" = {
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
    device = "/dev/disk/by-uuid/DA95-B183";
  };

  fileSystems."/boot/disk2" = {
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
    device = "/dev/disk/by-uuid/DA99-6768";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/369210d5-616b-4dbb-a6da-338e0ef8e99b"; }
    { device = "/dev/disk/by-uuid/216ce287-a433-4523-be97-3c6b871c6671"; }
  ];
}
