{config, lib, pkgs, inputs, ...}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  overview = inputs.overview.packages.${pkgs.system}.Hyprspace;
  devnotify = inputs.devnotify.packages.${pkgs.system}.devnotify;
  hyprsplit = inputs.hyprsplit.packages.${pkgs.system}.hyprsplit;
  easymotion = inputs.easymotion.packages.${pkgs.system}.hyprland-easymotion;
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
    portalPackage = xdg-desktop-portal-hyprland;
    plugins = [split-monitor-workspaces hyprsplit overview easymotion];
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  # Secrets and keys management
  programs.seahorse.enable = true; # cringe
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # needed for nautilus stuff
  services.gvfs.enable = true;
  programs.dconf.enable = true;
  services.gnome.sushi.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    clipse wl-clipboard
    waybar dunst anyrun kitty nautilus
    gtk-engine-murrine gnome-themes-extra
    grim slurp devnotify ffmpegthumbnailer
    killall xorg.xrandr libnotify playerctl
    kdePackages.breeze kdePackages.breeze-icons qt6ct
    hyprpaper hypridle hyprlock hyprpicker hyprpolkitagent
    adwaita-icon-theme phinger-cursors tokyonight-gtk-theme
  ];
}
