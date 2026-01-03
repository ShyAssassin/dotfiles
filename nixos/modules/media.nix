{ config, lib, pkgs, ... }: with lib; let
  cfg = config.modules.mediaServer;
  mkServiceOption = desc: defaultState: mkOption {
    type = types.bool;
    default = defaultState;
    description = "Enable the ${desc} service";
  };
  mkEnableService = name: setGroup: {
    ${name} = mkIf (cfg.services.${name}) ({
      enable = true;
      openFirewall = cfg.openFirewall;
    } // (optionalAttrs setGroup { group = cfg.mediaGroup; }));
  };

  jellyfinDomain = "jellyfin.${cfg.nginx.baseUrl}";
  jellyseerrDomain = "jellyseerr.${cfg.nginx.baseUrl}";

  torrentsDir = "${cfg.storageDir}/Torrents";
  inctorrentDir = "${cfg.storageDir}/Torrents/.incomplete";
in {
  options.modules.mediaServer = {
    enable = mkEnableOption "media server stack";

    mediaGroup = mkOption {
      type = types.str;
      default = "media";
      description = "Group name for media services";
    };

    storageDir = mkOption {
      type = types.path;
      default = "/mnt/Storage";
      description = "Base storage directory for media files";
    };

    peerPort = mkOption {
      default = 51413;
      type = types.port;
      description = "Default port for BitTorrent peer connections";
    };

    openFirewall = mkOption {
      default = true;
      type = types.bool;
      description = "Open firewall ports for all enabled services";
    };

    nginx = mkOption {
      default = {};
      type = types.submodule {
        options = {
          enable = mkOption {
            default = true;
            type = types.bool;
            description = "Enable Nginx for media services";
          };

          baseUrl = mkOption {
            type = types.str;
            default = "assassin.dev";
            description = "Base URL for media services";
          };

          enableSSL = mkOption {
            default = true;
            type = types.bool;
            description = "Enable SSL for Nginx virtual hosts";
          };
        };
      };
    };

    services = {
      sonarr = mkServiceOption "Sonarr show manager" true;
      radarr = mkServiceOption "Radarr movie manager" true;
      lidarr = mkServiceOption "Lidarr music manager" true;
      readarr = mkServiceOption "Readarr ebook manager" true;
      jellyfin = mkServiceOption "Jellyfin media server" true;
      bazarr = mkServiceOption "Bazarr subtitle manager" true;
      flaresolverr = mkServiceOption "FlareSolverr proxy" true;
      prowlarr = mkServiceOption "Prowlarr indexer manager" true;
      jellyseerr = mkServiceOption "Jellyseerr media requester" true;
      transmission = mkServiceOption "Transmission torrent client" true;
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.mediaGroup} = {};

    # Creates needed thingies
    systemd.tmpfiles.rules = [
      # Top level consumable media directories
      "d ${cfg.storageDir}/Anime 0775 sonarr ${cfg.mediaGroup} -"
      "d ${cfg.storageDir}/Shows 0775 sonarr ${cfg.mediaGroup} -"
      "d ${cfg.storageDir}/Music 0775 lidarr ${cfg.mediaGroup} -"
      "d ${cfg.storageDir}/Books 0775 readarr ${cfg.mediaGroup} -"
      "d ${cfg.storageDir}/Movies 0775 radarr ${cfg.mediaGroup} -"

      # Torrent and torrent clients download directories
      "d ${torrentsDir} 0775 transmission ${cfg.mediaGroup} -"
      "d ${inctorrentDir} 0775 transmission ${cfg.mediaGroup} -"
      "d ${torrentsDir}/lidarr 0775 transmission ${cfg.mediaGroup} -"
      "d ${torrentsDir}/radarr 0775 transmission ${cfg.mediaGroup} -"
      "d ${torrentsDir}/sonarr 0775 transmission ${cfg.mediaGroup} -"
      "d ${torrentsDir}/readarr 0775 transmission ${cfg.mediaGroup} -"
      "d ${torrentsDir}/prowlarr 0775 transmission ${cfg.mediaGroup} -"
    ];

    services = mkMerge [
      {transmission = mkIf cfg.services.transmission {
        enable = true;
        group = cfg.mediaGroup;
        package = pkgs.transmission_4;
        openRPCPort = cfg.openFirewall;
        openFirewall = cfg.openFirewall;
        openPeerPorts = cfg.openFirewall;
        webHome = pkgs.flood-for-transmission;
        settings = {
          peer-port = cfg.peerPort;
          rpc-bind-address = "0.0.0.0";
          rpc-whitelist-enabled = false;

          peer-limit-global = 256;
          blocklist-enabled = true;
          peer-limit-per-torrent = 16;
          download-queue-enabled = false;
          download-dir = "${torrentsDir}";
          incomplete-dir = "${inctorrentDir}";
          blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
        };
      };}

      {nginx.virtualHosts.${jellyseerrDomain} = {
        forceSSL = cfg.nginx.enableSSL;
        useACMEHost = cfg.nginx.baseUrl;
        # enableACME = cfg.nginx.enableSSL;

        extraConfig = ''
          client_max_body_size 20M;
          ssl_protocols TLSv1.3 TLSv1.2;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-Content-Type-Options "nosniff";
          add_header Strict-Transport-Security "max-age=31536000" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          extraConfig = ''
            proxy_set_header X-Forwarded-Ssl on;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };}

      {nginx.virtualHosts.${jellyfinDomain} = {
        forceSSL = cfg.nginx.enableSSL;
        useACMEHost = cfg.nginx.baseUrl;
        # enableACME = cfg.nginx.enableSSL;

        extraConfig = ''
          client_max_body_size 20M;
          ssl_protocols TLSv1.3 TLSv1.2;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-Content-Type-Options "nosniff";
          add_header Strict-Transport-Security "max-age=31536000" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_buffering off;
            proxy_request_buffering off;
            proxy_set_header X-Forwarded-Ssl on;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };

        locations."/socket" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_set_header Connection "upgrade";
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };}

      (mkEnableService "sonarr" true)
      (mkEnableService "radarr" true)
      (mkEnableService "lidarr" true)
      (mkEnableService "bazarr" true)
      (mkEnableService "readarr" true)
      (mkEnableService "jellyfin" true)
      (mkEnableService "prowlarr" false)
      (mkEnableService "jellyseerr" false)
      (mkEnableService "flaresolverr" false)
    ];
  };
}
