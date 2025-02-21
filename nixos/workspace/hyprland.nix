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

  environment.systemPackages = with pkgs; [
    grim slurp
    adwaita-icon-theme
    clipse wl-clipboard
    waybar dunst anyrun kitty
    killall xorg.xrandr libnotify playerctl
    hyprpaper hypridle hyprlock hyprpolkitagent hyprpicker
  ];
}
