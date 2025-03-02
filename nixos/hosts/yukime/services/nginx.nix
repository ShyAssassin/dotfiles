{config, lib, pkgs, ...}: {
  services.nginx.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    certs."assassin.dev" = {
      dnsProvider = "cloudflare";
      environmentFile = "/root/secrets/acme";
    };
    defaults.email = "ShyAssassin@assassin.dev";
  };

  services.nginx.virtualHosts."yukime.assassin.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      root = "/var/www/404";
    };
  };
}
