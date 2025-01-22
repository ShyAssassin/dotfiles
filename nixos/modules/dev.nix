{config, lib, pkgs, ...}: {
  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
