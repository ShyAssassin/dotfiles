{config, lib, pkgs, ...}: {
  programs.nix-ld.enable = true;

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    renderdoc
    vscode imhex
    gdb lldb tracy
    git gh lazygit github-desktop
    linuxKernel.packages.linux_6_6.perf
  ];
}
