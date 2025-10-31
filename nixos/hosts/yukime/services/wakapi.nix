{config, lib, pkgs, ...}: {
  services.wakapi = {
    enable = true;
    settings = {
      db = {
        dialect = "sqlite3";
        name = "/var/lib/wakapi/wakapi.db";
      };

      app = {
        import_enabled = true;
        leaderboard_enable = true;
        leaderboard_scope = "7_days";
        avatar_url_template = "https://github.com/{username}.png";
      };

      server = {
        port = 3120;
        # TODO: 0.0.0.0
        listen_ipv4 = "10.0.0.115";
        public_url = "https://waka.assassin.dev";
      };

      security = {
        invite_codes = true;
        allow_signup = false;
        insecure_cookies = false;
      };
    };
    database.dialect = "sqlite3";
    database.createLocally = false;
    passwordSaltFile = "/root/secrets/wakapi";
  };

  networking.firewall.allowedTCPPorts = [ 3120 ];

  services.nginx.virtualHosts."waka.assassin.dev" = {
    forceSSL = true;
    # enableACME = true;
    useACMEHost = "assassin.dev";

    locations."/" = {
      proxyPass = "http://10.0.0.115:3120";
    };
  };
}
