{config, lib, pkgs, ...}: {
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      custom = {
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode disabled'";
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode enabled'";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;
}
