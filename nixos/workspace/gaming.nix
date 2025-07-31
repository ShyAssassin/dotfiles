{config, lib, pkgs, ...}: {
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        reaper_freq = 5;
      };
      custom = {
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode disabled'";
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode enabled'";
      };
    };
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamescope = {
    enable = true;
    # currently broken
    capSysNice = false;
    package = pkgs.gamescope;
    args = ["--rt" "--force-grab-cursor"];
  };

  hardware.steam-hardware.enable = true;
  environment.systemPackages = with pkgs; [ mangohud protonplus ];
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
