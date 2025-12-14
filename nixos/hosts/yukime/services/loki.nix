{config, lib, pkgs, ...}: {
  services.loki = {
    enable = true;

    configuration = {
      auth_enabled = false;

      server = {
        log_level = "info";
        http_listen_port = 3100;
        grpc_listen_port = 9096;
      };

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/var/lib/loki";
        storage = {
          filesystem = {
            rules_directory = "/var/lib/loki/rules";
            chunks_directory = "/var/lib/loki/chunks";
          };
        };
        replication_factor = 1;
        ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };

      query_range = {
        results_cache = {
          cache = {
            embedded_cache = {
              enabled = true;
              max_size_mb = 100;
            };
          };
        };
      };

      schema_config = {
        configs = [{
          schema = "v13";
          store = "tsdb";
          from = "2020-10-24";
          object_store = "filesystem";
          index = {
            period = "24h";
            prefix = "index_";
          };
        }];
      };

      limits_config = {
        reject_old_samples = true;
        retention_period = "8760h";
        reject_old_samples_max_age = "168h";
      };

      compactor = {
        retention_enabled = true;
        retention_delete_delay = "2h";
        retention_delete_worker_count = 64;
        delete_request_store = "filesystem";
        working_directory = "/var/lib/loki/compactor";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3100 ];
}
