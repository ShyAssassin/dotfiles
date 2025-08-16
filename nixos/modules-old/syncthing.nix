{config, lib, pkgs, ...}: {
  services.syncthing = {
    enable = true;
    user = "assassin";
    group = "syncthing";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/assassin/Documents";
    configDir = "/home/assassin/.config/syncthing";
  };
  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  # TODO: do this the proper way
  # open the firewall for syncthing gui
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
