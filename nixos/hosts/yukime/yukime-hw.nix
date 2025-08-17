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
    swraid = {
      enable = true;
      mdadmConf = "PROGRAM /usr/bin/logger -t mdadm";
    };
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
  };

  hardware.nvidia = {
    open = false;
    enable = true;
    nvidiaSettings = false;
    enableCudaSupport = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
    device = "/dev/disk/by-uuid/12CE-A600";
  };

  fileSystems."/" = {
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/home" = {
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/nix" = {
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/var/log" = {
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=@log" "compress=zstd"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/snapshots" = {
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress=zstd"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/swap" = {
    fsType = "btrfs";
    options = ["subvol=@swap" "noatime"];
    device = "/dev/disk/by-uuid/8c021577-d8b0-4ba8-864b-7e1dbf0d421b";
  };

  fileSystems."/mnt/gura" = {
    fsType = "auto";
    options = ["nofail"];
    device = "/dev/disk/by-uuid/1030dc88-1eb3-4e00-8a07-9c3f25adc98d";
  };
}
