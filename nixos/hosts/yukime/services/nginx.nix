{config, lib, pkgs, ...}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    statusPage = true;
    appendHttpConfig = ''
      log_format logging '$remote_addr - $remote_user [$time_local] '
                         '"$request" $status $body_bytes_sent '
                         '"$http_referer" "$http_user_agent" "$http_x_forwarded_for" '
                         'rt=$request_time uct="$upstream_connect_time" '
                         'uht="$upstream_header_time" urt="$upstream_response_time"';

      log_format json_analytics escape=json '{'
        '"connection_requests": "$connection_requests", '
        '"request_length": "$request_length", '
        '"remote_addr": "$remote_addr", '
        '"request_uri": "$request_uri", '
        '"status": "$status", '
        '"bytes_sent": "$bytes_sent", '
        '"http_referer": "$http_referer", '
        '"http_user_agent": "$http_user_agent", '
        '"http_host": "$http_host", '
        '"upstream_connect_time": "$upstream_connect_time", '
        '"upstream_response_time": "$upstream_response_time", '
        '"ssl_protocol": "$ssl_protocol", '
        '"ssl_cipher": "$ssl_cipher", '
        '"scheme": "$scheme", '
        '"request_method": "$request_method", '
        '"server_protocol": "$server_protocol" '
      '}';

      access_log /var/log/nginx/access.log logging;
      access_log /var/log/nginx/website_access.log json_analytics;

      server {
        listen 127.0.0.1:8080;
        location /nginx_status {
          stub_status on;
          access_log off;
          allow 127.0.0.1;
          deny all;
        }
      }

      server {
        listen 80 default_server;
        listen 443 default_server;
        listen [::]:80 default_server;
        listen [::]:443 default_server;

        # Not the correct certificate, but its a 403 so we dont care
        ssl_certificate_key /var/lib/acme/yukime.assassin.dev/key.pem;
        ssl_certificate /var/lib/acme/yukime.assassin.dev/fullchain.pem;
        ssl_trusted_certificate /var/lib/acme/yukime.assassin.dev/chain.pem;

        return 403;
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    certs."assassin.dev" = {
      group = "nginx";
      domain = "*.assassin.dev";
      dnsProvider = "cloudflare";
      extraDomainNames = ["assassin.dev"];
      environmentFile = "/root/secrets/acme";
    };
    defaults.email = "ShyAssassin@assassin.dev";
  };

  services.nginx.virtualHosts."yukime.assassin.dev" = {
    forceSSL = true;
    # enableACME = true;
    useACMEHost = "assassin.dev";

    locations."/" = {
      root = "/var/www/403";
    };
  };
}
