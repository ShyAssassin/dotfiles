{config, lib, pkgs, ...}: {
  nix.settings = {
    log-lines = "35";
    max-jobs = "auto";
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
  };

  nix.gc = {
    dates = "daily";
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
