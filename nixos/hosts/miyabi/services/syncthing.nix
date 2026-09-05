{config, lib, pkgs, ...}: {
  services.syncthing = {
    enable = true;
    user = "assassin";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/assassin/Documents";
    configDir = "/home/assassin/.config/syncthing";

    settings = {
      devices = {
        "Senko" = { id = "NKARLM4-DURBWQC-YJRU2F2-W6YXYSI-FK7M45F-S42BPE3-RW7IILC-AKYN4AS"; };
        "Yukime" = { id = "MGTHG2V-HTOUSQR-PQORNVX-WG6OFUU-V2CD4ZE-DDH73EK-6MSYSUT-6H2HIQZ"; };
        "Satsuki" = { id = "ASFZCN5-GQFKE7T-GM5W7YQ-NRNRIHL-VFVWFQR-CVVT3JR-3VOT5TQ-VFUNOQ7"; };
      };

      folders = {
        "VRChat" = {
          id = "czy9z-eukyp";
          devices = [ "Senko" "Yukime" ];
          ignorePatterns = [ "(?d)desktop.ini" ];
          path = "/home/assassin/Pictures/VRChat";
        };
        "Dotfiles" = {
          id = "xj9km-7npqr";
          path = "/home/assassin/dotfiles";
          devices = [ "Senko" "Yukime" "Satsuki" ];
          ignorePatterns = [ "#include .gitignore" ];
        };
        "Screenshots" = {
          id = "m4wv2-8tfhz";
          devices = [ "Senko" "Yukime" ];
          ignorePatterns = [ "(?d)desktop.ini" ];
          path = "/home/assassin/Pictures/Screenshots";
        };
        "Development" = {
          id = "6qea3-gopcu";
          devices = [ "Senko" "Yukime" ];
          path = "/home/assassin/Development";
          ignorePatterns = [ "#include .stignore.common" ];
        };
      };
    };
  };

  # Used only during initial setup (—ᴗ—)
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
