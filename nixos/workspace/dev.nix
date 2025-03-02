{config, lib, pkgs, ...}: {
  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    renderdoc
    vscode imhex
    gdb lldb tracy
    git gh lazygit github-desktop
    linuxKernel.packages.linux_6_6.perf
  ];
}
