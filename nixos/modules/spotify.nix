{config, lib, pkgs, inputs, ...}: let
  apps = inputs.spicetify.legacyPackages.${pkgs.stdenv.system}.apps;
  themes = inputs.spicetify.legacyPackages.${pkgs.stdenv.system}.themes;
  extensions = inputs.spicetify.legacyPackages.${pkgs.stdenv.system}.extensions;
in {
  imports = [
    inputs.spicetify.nixosModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    theme = themes.comfy;
    colorScheme = "rose-pine";
    spotifyPackage = pkgs.spotify;
    enabledExtensions = with extensions; [
      shuffle
      goToSong
      queueTime
      adblockify
      hidePodcasts
      autoSkipVideo
      copyToClipboard
      showQueueDuration
    ];
    enabledCustomApps = with apps; [
      localFiles
      newReleases
      historyInSidebar
    ];
  };
}
