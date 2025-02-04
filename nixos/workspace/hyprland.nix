{config, lib, pkgs, inputs, ...}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  xdg-desktop-portal-hyprland = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  split-monitor-workspaces = inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = hyprland;
    xwayland.enable = true;
    plugins = [split-monitor-workspaces];
    portalPackage = xdg-desktop-portal-hyprland;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    font-awesome
  ];

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  environment.systemPackages = with pkgs; [
    waybar
    playerctl
    grim slurp
    kitty anyrun
    dunst libnotify
    clipse wl-clipboard
    hyprpaper hypridle hyprlock
    killall hyprpolkitagent xorg.xrandr
  ];
}
