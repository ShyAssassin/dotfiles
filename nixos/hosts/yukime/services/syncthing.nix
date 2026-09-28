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
        "Miyabi" = { id = "UFT7F4I-45QE4AW-WERJXIH-C645UCO-Q4DDEOH-OWP6OVI-LHQRRYV-JSYJAA7"; };
        "Satsuki" = { id = "ASFZCN5-GQFKE7T-GM5W7YQ-NRNRIHL-VFVWFQR-CVVT3JR-3VOT5TQ-VFUNOQ7"; };
      };

      folders = {
        "VRChat" = {
          id = "czy9z-eukyp";
          devices = [ "Senko" "Miyabi"];
          path = "/mnt/gura/syncthing/VRChat";
          ignorePatterns = [ "(?d)desktop.ini" ];
        };
        "Dotfiles" = {
          id = "xj9km-7npqr";
          path = "/home/assassin/dotfiles";
          devices = [ "Senko" "Miyabi" "Satsuki" ];
          ignorePatterns = [ "#include .gitignore" ];
        };
        "Screenshots" = {
          id = "m4wv2-8tfhz";
          devices = [ "Senko" "Miyabi" ];
          ignorePatterns = [ "(?d)desktop.ini" ];
          path = "/mnt/gura/syncthing/Screenshots";
        };
        "Development" = {
          id = "6qea3-gopcu";
          devices = [ "Senko" "Miyabi" ];
          path = "/mnt/gura/syncthing/Development";
          ignorePatterns = [ "#include .stignore.common" ];
        };
      };
    };
  };

  # Used only during initial setup (—ᴗ—)
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
