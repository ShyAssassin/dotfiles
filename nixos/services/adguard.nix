{config, lib, pkgs, ...}: {
  services.adguardhome = {
    port = 9092;
    enable = true;
    allowDHCP = true;
    openFirewall = true;
  };

  # Allow DNS and DHCP ports
  networking.firewall.allowedTCPPorts = [ 53 67 68 ];
  networking.firewall.allowedUDPPorts = [ 53 67 68 ];
}
