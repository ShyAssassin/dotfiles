{config, lib, pkgs, ...}: {
  services.syncthing = {
    enable = true;
    user = "assassin";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/assassin/Documents";
    configDir = "/home/assassin/.config/syncthing";

    folderPaths.Dotfiles = "/home/assassin/dotfiles";
    folderPaths.VRChat = "/mnt/gura/syncthing/VRChat";
    folderPaths.Development = "/home/assassin/Development";
    folderPaths.Screenshots = "/mnt/gura/syncthing/Screenshots";
  };

  # Used only during initial setup (—ᴗ—)
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
