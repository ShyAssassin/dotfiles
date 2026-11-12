{ lib, config, ... }: with lib; let
  cfg = config.services.syncthing;

  syncthingFolders = {
    VRChat = {
      id = "czy9z-eukyp";
      ignorePatterns = [ "(?d)desktop.ini" ];
      participants = [ "Senko" "Yukime" "Miyabi" ];
    };
    Dotfiles = {
      id = "xj9km-7npqr";
      ignorePatterns = [ "#include .gitignore" ];
      participants = [ "Senko" "Yukime" "Miyabi" "Satsuki" ];
    };
    Screenshots = {
      id = "m4wv2-8tfhz";
      ignorePatterns = [ "(?d)desktop.ini" ];
      participants = [ "Senko" "Yukime" "Miyabi" ];
    };
    Development = {
      id = "6qea3-gopcu";
      participants = [ "Senko" "Yukime" "Miyabi" ];
      ignorePatterns = [ "#include .stignore.common" ];
    };
  };

  syncthingDevices = {
    Senko = "NKARLM4-DURBWQC-YJRU2F2-W6YXYSI-FK7M45F-S42BPE3-RW7IILC-AKYN4AS";
    Yukime = "MGTHG2V-HTOUSQR-PQORNVX-WG6OFUU-V2CD4ZE-DDH73EK-6MSYSUT-6H2HIQZ";
    Miyabi  = "UFT7F4I-45QE4AW-WERJXIH-C645UCO-Q4DDEOH-OWP6OVI-LHQRRYV-JSYJAA7";
    Satsuki  = "ASFZCN5-GQFKE7T-GM5W7YQ-NRNRIHL-VFVWFQR-CVVT3JR-3VOT5TQ-VFUNOQ7";
  };

  invalidFolderParticipants = flatten (mapAttrsToList
    (folderName: folder:
      map
        (participant:
          "'${folderName}' references nonexistent participant '${participant}'")
        (filter (participant: !hasAttr participant syncthingDevices) folder.participants))
    syncthingFolders);

in {
  options.services.syncthing = {
    folderPaths = mkOption {
      default = {};
      type = types.attrsOf types.str;
      description = ''
        Per-host Syncthing folder paths keyed by known folder name.
        Example: { Development = "/home/assassin/Development"; }
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = invalidFolderParticipants == [];
      message = concatStringsSep "\n" invalidFolderParticipants;
    }];

    services.syncthing.settings.devices = (mapAttrs (deviceName: id: { inherit id; })
      # We dont want to add the device that is the same as the hostname, so we filter it out :3
      (filterAttrs (deviceName: _: toLower deviceName != toLower config.networking.hostName) syncthingDevices)
    );

    services.syncthing.settings.folders = (
      mapAttrs (folderName: folder: {
        id = folder.id;
        path = cfg.folderPaths.${folderName};
        # Same thing as above, dont add ourselves as a participant
        devices = filter(p: toLower p != toLower config.networking.hostName)folder.participants;
      }) # Because i dislike myself and the let syntax in nix we do this horrible thing to filter stuff
      (filterAttrs (folderName: folder: # I told you, this is not readable like at all, but it works ¯\_(ツ)_/¯
        any (p: toLower p == toLower config.networking.hostName) folder.participants && hasAttr folderName cfg.folderPaths)
        syncthingFolders # All this basically does is to filter out folders that dont have a path defined in the host's config
      )
    );
  };
}
