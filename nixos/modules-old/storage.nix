{config, lib, pkgs, ...}: {
  nix.gc = {
    dates = "daily";
    automatic = true;
    options = "--delete-older-than 7d";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/"];
    interval = "monthly";
  };

  boot.tmp.cleanOnBoot = true;
  nix.settings.auto-optimise-store = true;
}
