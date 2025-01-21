{config, lib, pkgs, ...}: {
  services.syncthing = {
    enable = true;
    user = "assassin";
    # group = "assassin";
    openDefaultPorts = true;
    dataDir = "/home/assassin/Documents";
    configDir = "/home/assassin/.config/syncthing";
  };
  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
