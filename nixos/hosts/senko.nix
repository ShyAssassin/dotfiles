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
    neovim
    rustup
    neovim
    vscode
    vesktop
    raycast
    firefox-unwrapped
  ];

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
  };

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
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
  };

  # nix.extraOptions = ''
  #   extra-platforms = x86_64-darwin aarch64-darwin
  # '';
  # inputs.self.allowUnsupportedSystem = true;
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
}
