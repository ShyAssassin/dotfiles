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

  # Secrets and keys management
  programs.seahorse.enable = true; # cringe
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # needed for nautilus stuff
  services.gvfs.enable = true;
  programs.dconf.enable = true;
  services.gnome.sushi.enable = true;

  environment.systemPackages = with pkgs; [
    grim slurp
    adwaita-icon-theme
    clipse wl-clipboard
    waybar dunst anyrun kitty nautilus
    killall xorg.xrandr libnotify playerctl
    hyprpaper hypridle hyprlock hyprpicker hyprpolkitagent
  ];
}
