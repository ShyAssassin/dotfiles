{config, lib, pkgs, ...}: {
  programs.nix-ld.enable = true;

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      mandoc.enable = true;
      generateCaches = true;
      man-db.enable = false;
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    prompt.enable = true;
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  environment.systemPackages = with pkgs; [
    renderdoc
    vscode imhex
    gdb lldb tracy
    bat bat-extras.batman
    git gh lazygit github-desktop
    config.boot.kernelPackages.perf
    # https://github.com/NixOS/nixpkgs/issues/489956
    # linux-manual man-pages man-pages-posix
  ];
}
