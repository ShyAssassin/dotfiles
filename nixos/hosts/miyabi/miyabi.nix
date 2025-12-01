{config, lib, pkgs, ...}: {
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Africa/Johannesburg";

  networking = {
    hostName = "miyabi";
    firewall.enable = true;
    networkmanager.enable = true;
  };

  services.tailscale.enable = true;
  services.displayManager.ly.enable = true;

  # Select internationalisation properties.
  console = {
    keyMap = "us";
    useXkbConfig = false;
    font = "Lat2-Terminus16";
  };
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb.layout = "za";
  services.xserver.xkb.options = "";

  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  programs.fish.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  users.users.assassin = {
    createHome = true;
    isNormalUser = true;
    description = "[Assassin]";
    extraGroups = ["wheel" "networkmanager" "libvirtd" "gamemode"];
    packages = with pkgs; [
      yubioath-flutter
      unstable.vesktop
      signal-desktop
      unstable.vrcx
      mangohud
      bottles
      vlc
    ];
  };

  systemd.user.services.arRPC = {
    serviceConfig = {
      Restart = "always";
      ExecStart = lib.getExe pkgs.arrpc;
    };
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
  };

  programs.firefox.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    neovim
    fastfetch
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

