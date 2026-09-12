{config, lib, pkgs, ...}: {
  networking.hostId = "6f7e9149";
  networking.hostName = "satsuki";
  networking.firewall.enable = true;
  time.timeZone = "Africa/Johannesburg";
  networking.networkmanager.enable = true;
  services.openssh.enable = lib.mkForce true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;

    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot/usb";  }
      { devices = [ "nodev" ]; path = "/boot/disk1"; }
      { devices = [ "nodev" ]; path = "/boot/disk2"; }
    ];
  };

  users.users.assassin = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim tmux
    btop neovim
  ];

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
  system.stateVersion = "26.05"; # Did you read the comment?

}

