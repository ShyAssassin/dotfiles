{config, lib, pkgs, ...}: {
  services.prometheus = {
    port = 9090;
    enable = true;
    retentionTime = "365d";

    exporters = {
      node = {
        port = 9100;
        enable = true;
        enabledCollectors = [
          "entropy" "cpu"
          "sockstat" "time"
          "meminfo" "netdev"
          "netstat" "softnet"
          "vmstat" "conntrack"
          "systemd" "processes"
          "filesystem" "loadavg"
          "interrupts" "diskstats"
        ];
      };

      nginx = {
        port = 9113;
        enable = true;
        group = "nginx";
        scrapeUri = "http://localhost:8080/nginx_status";
      };

      nginxlog = {
        port = 9117;
        enable = true;
        group = "nginx";
        settings = {
          consul.enable = false;
          namespaces = [{
            name = "nginx";
            format = lib.concatStringsSep " " [
              "$remote_addr - $remote_user [$time_local]"
              ''"$request" $status $body_bytes_sent''
              ''"$http_referer" "$http_user_agent" "$http_x_forwarded_for"''
              ''rt=$request_time uct="$upstream_connect_time"''
              ''uht="$upstream_header_time" urt="$upstream_response_time"''
            ];
            source.files = [ "/var/log/nginx/access.log" ];
          }];
        };
      };

      systemd = {
        port = 9558;
        enable = true;
      };

      smartctl = {
        port = 9633;
        enable = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.port}"];
        }];
      }
      {
        job_name = "grafana";
        static_configs = [{
          targets = ["localhost:${toString config.services.grafana.settings.server.http_port}"];
        }];
      }
      {
        job_name = "node";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
        }];
      }
      {
        job_name = "nginx";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.exporters.nginx.port}"];
        }];
      }
      {
        job_name = "nginxlog";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.exporters.nginxlog.port}"];
        }];
      }
      {
        job_name = "systemd";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.exporters.systemd.port}"];
        }];
      }
      {
        job_name = "smartctl";
        static_configs = [{
          targets = ["localhost:${toString config.services.prometheus.exporters.smartctl.port}"];
        }];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 9090 ];
}
