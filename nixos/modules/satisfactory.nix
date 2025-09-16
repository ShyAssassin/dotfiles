{ config, lib, pkgs, ... }: with lib; let
  cfg = config.modules.satisfactory;
  portArgs = "-Port=${toString cfg.port} -ReliablePort=${toString cfg.reliablePort}";
in {
  options.modules.satisfactory = {
    enable = mkEnableOption "Satisfactory server";

    storageDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/satisfactory";
      description = "Directory to store game data";
    };

    openFirewall = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Open firewall ports for the Satisfactory server";
    };

    port = lib.mkOption {
      default = 7777;
      type = lib.types.port;
      description = "Game port";
    };

    reliablePort = lib.mkOption {
      default = 8888;
      type = lib.types.port;
      description = "Reliable port";
    };

    maxPlayers = lib.mkOption {
      default = 4;
      type = lib.types.number;
      description = "Maximum number of players";
    };

    autoPause = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Auto pause when no players are on";
    };

    autoSaveOnDisconnect = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Auto save when on a player disconnect";
    };
  };

  config = mkIf cfg.enable {
    users.users.satisfactory = {
      createHome = true;
      isSystemUser = true;
      home = cfg.storageDir;
      group = "satisfactory";
    };
    users.groups.satisfactory = {};

    systemd.services.satisfactory = {
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      preStart = ''
        ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir ${cfg.storageDir} \
          +login anonymous \
          +app_update 1690800 validate \
        +quit

        chmod +x ${cfg.storageDir}/FactoryServer.sh
        mkdir -p ${cfg.storageDir}/FactoryGame/Saved/Config/LinuxServer
        ln -sf ${cfg.storageDir}/.steam/steam/linux64 ${cfg.storageDir}/.steam/sdk64
        chmod +x ${cfg.storageDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping
        ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ${cfg.storageDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping
        ${pkgs.crudini}/bin/crudini --set ${cfg.storageDir}/FactoryGame/Saved/Config/LinuxServer/Game.ini '/Script/Engine.GameSession' MaxPlayers ${toString cfg.maxPlayers}
        ${pkgs.crudini}/bin/crudini --set ${cfg.storageDir}/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoPause ${if cfg.autoPause then "True" else "False"}
        ${pkgs.crudini}/bin/crudini --set ${cfg.storageDir}/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoSaveOnDisconnect ${if cfg.autoSaveOnDisconnect then "True" else "False"}
      '';

      script = ''
        export LD_LIBRARY_PATH=linux64:Engine/Binaries/Linux
        ${pkgs.bash}/bin/bash ${cfg.storageDir}/FactoryServer.sh ${portArgs}
      '';

      serviceConfig = {
        RestartSec = "15s";
        User = "satisfactory";
        Group = "satisfactory";
        Restart = "on-failure";
        WorkingDirectory = cfg.storageDir;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ cfg.port ];
      allowedTCPPorts = [ cfg.port cfg.reliablePort ];
    };
  };
}
