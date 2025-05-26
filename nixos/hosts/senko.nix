# Yes i know MacOS is not NixOS
{pkgs, lib, inputs, ...}: {
  system.stateVersion = 6;
  networking.hostName = "senko";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = inputs.self.rev or null;
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    git
    btop
    miru
    cmake
    kitty
    neovim
    rustup
    neovim
    vscode
    vlc-bin
    vesktop
    raycast
    firefox-unwrapped
  ];

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
  };

  system.primaryUser = "assassin";
  system.defaults = {
    dock = {
      autohide = false;
      static-only = false;
      show-recents = false;
      orientation = "bottom";
      show-process-indicators = true;
    };
    finder = {
      ShowPathbar = true;
      NewWindowTarget = "Home";
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      NSWindowShouldDragOnGesture = true;
    };
    CustomUserPreferences = {
      "com.apple.AdLib" = {
        forceLimitAdTracking = true;
        personalizedAdsMigrated = false;
        allowIdentifierForAdvertising = false;
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.desktopservices" = {
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };
    };
  };

  launchd.daemons = {
    syncthing = {
      command = "${pkgs.syncthing}/bin/syncthing";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };

  # nix.extraOptions = ''
  #   extra-platforms = x86_64-darwin aarch64-darwin
  # '';
  # inputs.self.allowUnsupportedSystem = true;
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
}
