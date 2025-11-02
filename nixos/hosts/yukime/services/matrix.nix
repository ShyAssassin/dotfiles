{config, lib, pkgs, ...}: {
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      port = [ 6167 ];
      allow_federation = true;
      allow_registration = false;
      server_name = "assassin.dev";
      address = [ "127.0.0.1" "::1" ];
      new_user_displayname_suffix = "";
      registration_token = "SuperSecret";
      max_request_size = 32000000; # 32 MB
      trusted_servers = ["matrix.org" "nixos.org"];
      well_known = {
        server = "matrix.assassin.dev:443";
        client = "https://matrix.assassin.dev";
      };
    };
  };

  services.heisenbridge = {
    enable = true;
    owner = "@shyassassin:assassin.dev";
    homeserver = "https://matrix.assassin.dev";
    extraArgs = ["--config" "/var/lib/heisenbridge/config.yml"];
  };

  networking.firewall.allowedUDPPorts = [ 8448 ];
  networking.firewall.allowedTCPPorts = [ 443 8448 ];

  services.nginx.virtualHosts."matrix.assassin.dev" = {
    forceSSL = true;
    # enableACME = true;
    useACMEHost = "assassin.dev";

    listen = [
      {
        port = 443;
        addr = "[::0]";
        ssl = true;
      }
      {
        port = 8448;
        addr = "[::0]";
        ssl = true;
      }
      {
        port = 443;
        addr = "0.0.0.0";
        ssl = true;
      }
      {
        port = 8448;
        addr = "0.0.0.0";
        ssl = true;
      }
    ];

    extraConfig = ''
      merge_slashes off;
      client_max_body_size 32M;
      proxy_set_header Host $host;
      ssl_protocols TLSv1.3 TLSv1.2;
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-Content-Type-Options "nosniff";
      add_header Strict-Transport-Security "max-age=31536000" always;
      add_header Referrer-Policy "strict-origin-when-cross-origin" always;
      add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
      add_header Access-Control-Allow-Headers "X-Requested-With, Content-Type, Authorization" always;
    '';

    locations = {
      "/_matrix/" = {
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:6167$request_uri";
      };
      # "/".return= "301 https://assassin.dev$request_uri";
      "/".proxyPass = "http://127.0.0.1:6167$request_uri";
      "/_conduwuit/".proxyPass = "http://127.0.0.1:6167$request_uri";
      "/.wellknown/matrix/".proxyPass = "http://127.0.0.1:6167$request_uri";
    };
  };
}
