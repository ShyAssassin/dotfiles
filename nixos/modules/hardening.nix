{ config, lib, ... }: with lib; let
  cfg = config.modules.hardening;
in {
  options.modules.hardening = {
    ssh = mkOption {
      type = types.bool;
      description = "Enable SSH hardening";
      default = config.services.openssh.enable;
    };
  };

  config = mkMerge [
    (mkIf cfg.ssh {
      services.fail2ban.enable = true;
      services.openssh = {
        authorizedKeysInHomedir = false;
        settings = {
          X11Forwarding = mkDefault false;
          PermitRootLogin = "prohibit-password";
        };
      };
    })
  ];
}
