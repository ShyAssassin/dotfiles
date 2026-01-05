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
    kernelPackages = pkgs.linuxPackages;
    kernelParams = ["amd_iommu=on" "iommu=pt"];
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
    # https://github.com/NixOS/nixpkgs/pull/458794
    # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/960
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "580.95.05";
    #   openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
    #   sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
    #   sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
    #   settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
    #   persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
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
    fsType = "ntfs";
    options = ["rw" "uid=1000" "nofail"];
    device = "/dev/disk/by-uuid/DA3C5AC23C5A98F9";
  };
}
