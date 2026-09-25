{config, lib, pkgs, inputs, outputs, ...}: with lib; {
  nix.settings = {
    log-lines = "35";
    max-jobs = "auto";
    auto-optimise-store = true;
    nix-path = config.nix.nixPath;
    trusted-users = [ "root" "assassin" ];
    experimental-features = "nix-command flakes";
  };

  nix.gc = {
    automatic = true;
    dates = mkDefault "weekly";
    options = "--delete-older-than 7d";
  };

  imports = [
    ./users.nix
    ./asyncthing.nix
  ] ++ (mapAttrsToList
    (name: module: "${./modules/${name}.nix}")
    (filterAttrs (_: v: v != null) outputs.nixosModules)
  );

  nixpkgs.config.allowUnfree = mkDefault true;
  nixpkgs.overlays = (attrValues outputs.overlays or []) ++ [
    (final: _prev: import ./overlay.nix { inherit final inputs; })
  ];
}
