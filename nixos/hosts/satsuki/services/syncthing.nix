{config, lib, pkgs, ...}: {
  services.syncthing = {
    enable = true;
    user = "assassin";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/assassin/Documents";
    configDir = "/home/assassin/.config/syncthing";

    folderPaths.Dotfiles = "/home/assassin/dotfiles";
  };

  # Used only during initial setup (—ᴗ—)
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
