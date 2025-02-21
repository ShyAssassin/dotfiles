{config, lib, pkgs, ...}: {
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
