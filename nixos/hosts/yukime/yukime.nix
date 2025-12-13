{config, lib, pkgs, ...}: {
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Africa/Johannesburg";

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  modules.satisfactory.enable = true;

  networking = {
    useDHCP = false;
    hostName = "yukime";
    firewall.enable = true;
    networkmanager.enable = true;
    defaultGateway = "10.0.0.254";
    # Tailscale is doing something fucky
    nameservers = ["1.1.1.1" "127.0.0.1"];
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

  modules.mediaServer.enable = true;

  users.users.assassin = {
    isNormalUser = true;
    packages = with pkgs; [];
    extraGroups = ["wheel" "media"];
  };

  users.users.durpy = {
    isNormalUser = true;
    extraGroups = ["media"];
    packages = with pkgs; [];
  };

  users.users.kitty = {
    extraGroups = [];
    isNormalUser = true;
    packages = with pkgs; [];
  };

  users.users.tina = {
    extraGroups = [];
    isNormalUser = true;
    packages = with pkgs; [];
  };

  users.users.quinten = {
    extraGroups = [];
    isNormalUser = true;
    packages = with pkgs; [];
  };

  users.users.pixel = {
    isNormalUser = true;
    extraGroups = ["media"];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim tmux
    btop neovim
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

