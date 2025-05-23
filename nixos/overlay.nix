{inputs, ...}: {
  additions = final: _prev: import ./packages final.pkgs;

  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    vesktop = (prev.vesktop.override {
      withTTS = false;
      withMiddleClickScroll = true;
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
