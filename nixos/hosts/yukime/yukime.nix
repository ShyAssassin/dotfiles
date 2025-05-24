{config, lib, pkgs, ...}: {
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Africa/Johannesburg";

  networking = {
    useDHCP = false;
    hostName = "yukime";
    firewall.enable = true;
    networkmanager.enable = true;
    defaultGateway = "10.0.0.254";
    interfaces = {
      enp34s0 = {
        ipv4 = {
          addresses = [{
            prefixLength = 24;
            address = "10.0.0.115";
          }];
        };
      };
    };
  };

  users.users.assassin = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+kNski6X9Vot6gej9aNj0b+CCyjC19gCAQGOGOvsc8"];
  };

  users.users.durpy = {
    extraGroups = [];
    isNormalUser = true;
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWjNu6Blw8q7dto9tCEVebroFJ0MLRvr0NVFPLzoevS"];
  };

  users.users.kitty = {
    extraGroups = [];
    isNormalUser = true;
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2UFubyRdz4RB4t36hVW9cOXbO7OFfZCrpeKWVc+MJP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYZEUV4P2SLD2YCJ0p4rCcsJ4MhHYjUMK9GFwvwvTrn"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

