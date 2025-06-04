{inputs, ...}: {
  additions = final: _prev: import ./packages final.pkgs;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    vesktop = (prev.vesktop.override {
      withTTS = false;
      withMiddleClickScroll = true;
    });
    bottles = (prev.bottles.override {
      removeWarningPopup = true;
    });
    miru = prev.miru.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or []) ++ [prev.makeWrapper];
      buildCommand = (oldAttrs.buildCommand or "") + ''
        wrapProgram $out/bin/miru --unset ELECTRON_OZONE_PLATFORM_HINT
      '';
    });
  };
}
