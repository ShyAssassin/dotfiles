{config, lib, pkgs, ...}: {
  # add promtail user to nginx group
  services.promtail = {
    enable = true;

    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };

      positions = {
        filename = "/var/lib/promtail/positions.yaml";
      };

      clients = [{
        url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];

      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "yukime";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
            {
              source_labels = ["__journal__hostname"];
              target_label = "hostname";
            }
          ];
        }
        {
          job_name = "nginx";
          static_configs = [{
            targets = ["localhost"];
            labels = {
              job = "nginx";
              host = "yukime";
              __path__ = "/var/log/nginx/*.log";
            };
          }];
        }
        {
          job_name = "sshd";
          journal = {
            max_age = "12h";
            labels = {
              job = "sshd";
              host = "yukime";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              regex = "sshd.service";
              action = "keep";
            }
          ];
        }
      ];
    };
  };

  users.users.promtail.extraGroups = [ "nginx" ];
}
