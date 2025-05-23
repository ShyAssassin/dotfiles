{config, lib, pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  # VNyan
  networking.firewall.allowedUDPPorts = [ 50509 ];
}
