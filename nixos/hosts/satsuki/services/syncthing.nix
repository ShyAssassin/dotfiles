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
        "Senko" = { id = "NKARLM4-DURBWQC-YJRU2F2-W6YXYSI-FK7M45F-S42BPE3-RW7IILC-AKYN4AS";  };
        "Yukime" = { id = "MGTHG2V-HTOUSQR-PQORNVX-WG6OFUU-V2CD4ZE-DDH73EK-6MSYSUT-6H2HIQZ"; };
        "Miyabi" = { id = "UFT7F4I-45QE4AW-WERJXIH-C645UCO-Q4DDEOH-OWP6OVI-LHQRRYV-JSYJAA7"; };
      };

      folders = {
        "Dotfiles" = {
          id = "xj9km-7npqr";
          path = "/home/assassin/dotfiles";
          devices = [ "Senko" "Yukime" "Miyabi" ];
          ignorePatterns = [ "#include .gitignore" ];
        };
      };
    };
  };

  # Used only during initial setup (—ᴗ—)
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
