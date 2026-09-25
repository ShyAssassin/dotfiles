{ lib, config, ... }: with lib; let
  cfg = config.services.syncthing;

  syncthingDevices = {
    Senko = "NKARLM4-DURBWQC-YJRU2F2-W6YXYSI-FK7M45F-S42BPE3-RW7IILC-AKYN4AS";
    Yukime = "MGTHG2V-HTOUSQR-PQORNVX-WG6OFUU-V2CD4ZE-DDH73EK-6MSYSUT-6H2HIQZ";
    Miyabi  = "UFT7F4I-45QE4AW-WERJXIH-C645UCO-Q4DDEOH-OWP6OVI-LHQRRYV-JSYJAA7";
    Satsuki  = "ASFZCN5-GQFKE7T-GM5W7YQ-NRNRIHL-VFVWFQR-CVVT3JR-3VOT5TQ-VFUNOQ7";
  };
in {
  options.services.syncthing.addKnownDevices = mkOption {
    default = true;
    type = types.bool;
    description = "Add known devices from asyncthing.nix";
  };

  config = mkIf (cfg.enable && cfg.addKnownDevices) {
    services.syncthing.settings.devices = mapAttrs (deviceName: id: { inherit id; })
      # We dont want to add the device that is the same as the hostname, so we filter it out :3
      (filterAttrs (deviceName: _: toLower deviceName != toLower config.networking.hostName) syncthingDevices);
  };
}
