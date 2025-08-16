{config, lib, pkgs, ...}: {
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 25;
    };
    efi.canTouchEfiVariables = true;
  };
}
