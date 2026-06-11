{ config, lib, ... }: with lib; let
  cfg = config.modules.hardening;
in {
  options.modules.hardening = {
    ssh = mkOption {
      type = types.bool;
      description = "Enable SSH hardening";
      default = config.services.openssh.enable;
    };
    kernel = mkOption {
      default = true;
      type = types.bool;
      description = "Enable kernel hardening";
    };
  };

  config = mkMerge [
    (mkIf cfg.ssh {
      services.fail2ban.enable = true;
      services.openssh = {
        authorizedKeysInHomedir = false;
        settings = {
          MaxSessions = mkDefault 3;
          PermitEmptyPasswords = false;
          PermitUserEnvironment = false;
          X11Forwarding = mkDefault false;
          PermitRootLogin = "prohibit-password";
        };
      };
    })

    (mkIf cfg.kernel {
      boot.kernelParams = [];

      boot.blacklistedKernelModules = [
        # Rare protocols
        "6lowpan" "appletalk"
        "atm" "ax25" "can" "can-raw"
        "caif" "dccp" "decnet" "econet"
        "lapb" "llc" "llc2" "n_hdlc" "netrom"
        "nfc" "p8022" "p8023" "phonet" "psnap"
        "rds" "rose" "rxrpc" "sctp" "tipc" "x25"

        # Rare filesystems
        "9p" "adfs" "affs" "befs"
        "ceph" "coda" "cramfs" "efs"
        "erofs" "f2fs" "freevxfs" "gfs2"
        "hfs" "hfsplus" "hpfs" "jfs" "jffs2"
        "minix" "nilfs2" "ocfs2" "omfs" "qnx4"
        "qnx6" "reiserfs" "sysv" "udf" "ufs" "xiafs"

        # Misc
        "ksmbd" "pcskr" "vivid"
      ];

      boot.kernel.sysctl = {
        "kernel.kptr_restrict" = 1;
        "kernel.dmesg_restrict" = 1;
        "kernel.unprivileged_bpf_disabled" = 1;
      };
    })
  ];
}
