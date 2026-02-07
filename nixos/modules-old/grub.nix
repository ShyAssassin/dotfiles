{config, lib, pkgs, ...}: {
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 25;
      memtest86 = {
        enable = true;
        params = ["btrace"];
      };
    };
    efi.canTouchEfiVariables = true;
  };
}
