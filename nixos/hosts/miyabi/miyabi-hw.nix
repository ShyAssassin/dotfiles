{config, lib, pkgs, modulesPath, ...}: {
  imports =[(modulesPath + "/installer/scan/not-detected.nix")];

  networking.useDHCP = lib.mkDefault true;
  swapDevices = [ { device = "/swap/swapfile"; } ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    extraModulePackages = [ ];
    initrd.kernelModules = [ ];
    kernelModules = ["kvm-amd"];
    supportedFilesystems = ["ntfs"];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
    device = "/dev/disk/by-uuid/12CE-A600";
  };

  fileSystems."/" ={
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/home" = {
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/nix" = {
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/var/log" = {
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=@log" "compress=zstd"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/snapshots" = {
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress=zstd"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/swap" = {
    fsType = "btrfs";
    options = ["subvol=@swap" "noatime"];
    device = "/dev/disk/by-uuid/8f135b5b-be57-4ffb-92ac-330a48606de5";
  };

  fileSystems."/mnt/Games" = {
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000"];
    device = "/dev/disk/by-uuid/DA3C5AC23C5A98F9";
  };
}
