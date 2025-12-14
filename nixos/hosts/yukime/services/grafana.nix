{config, lib, pkgs, ...}: {
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_port = 3000;
        http_addr = "0.0.0.0";
        domain = "grafana.assassin.dev";
        root_url = "https://grafana.assassin.dev";
      };

      security = {
        admin_user = "admin";
        admin_password = "changeme";
      };

      analytics = {
        reporting_enabled = false;
        check_for_updates = false;
      };

      database = {
        wal = true;
      };

      users = {
        auto_purge_expired_tokens_enabled = true;
      };
    };

    provision = {
      enable = true;

      datasources.settings = {
        apiVersion = 1;

        datasources = [
          {
            isDefault = true;
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:${toString config.services.prometheus.port}";
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}";
          }
        ];
      };

      dashboards.settings = {
        apiVersion = 1;
        providers = [{
          orgId = 1;
          folder = "";
          type = "file";
          editable = true;
          name = "default";
          disableDeletion = false;
          options = {
            path = "/var/lib/grafana/dashboards";
          };
        }];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
