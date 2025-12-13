{ lib, ... }: with lib; let
  sshKeys = {
    assassin = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+kNski6X9Vot6gej9aNj0b+CCyjC19gCAQGOGOvsc8"
    ];

    durpy = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWjNu6Blw8q7dto9tCEVebroFJ0MLRvr0NVFPLzoevS"
    ];

    kitty = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2UFubyRdz4RB4t36hVW9cOXbO7OFfZCrpeKWVc+MJP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYZEUV4P2SLD2YCJ0p4rCcsJ4MhHYjUMK9GFwvwvTrn"
    ];

    tina = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmuHyyOtAxG1GSuqIoeeGfV8XfLQGzS6zalYuAumlD+"
    ];

    quinten = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCqf7igKE0dymwQUoBV0Wrxh7GTMb4oU6KDJMNzTQ4+"
    ];

    pixel = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9LrY5EExHHHuuAmU/dAGjFcLOeEg2rnsUHOGD1ZrNu"
    ];
  };
in {
  options.users.users = mkOption {
    type = types.attrsOf (types.submodule ({ name, config, ... }: {
      options.syncSshKey = mkOption {
        default = true;
        type = types.bool;
        description = "Add SSH keys from users.nix";
      };

      config = mkIf (config.syncSshKey && sshKeys ? ${name}) {
        openssh.authorizedKeys.keys = mkDefault sshKeys.${name};
      };
    }));
  };
}
