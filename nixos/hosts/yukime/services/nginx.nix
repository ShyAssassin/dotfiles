{config, lib, pkgs, ...}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    appendHttpConfig = ''
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
