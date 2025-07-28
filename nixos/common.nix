{config, lib, pkgs, inputs, outputs, ...}: {
  nix.settings = {
    log-lines = "35";
    max-jobs = "auto";
    auto-optimise-store = true;
    nix-path = config.nix.nixPath;
    experimental-features = "nix-command flakes";
  };

  nix.gc = {
    dates = "daily";
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = (lib.attrValues outputs.overlays or []) ++ [
    (final: _prev: import ./overlay.nix { inherit final inputs; })
  ];
}
