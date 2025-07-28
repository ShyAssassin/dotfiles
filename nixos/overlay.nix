{inputs, ...}: {
  additions = final: _prev: import ./packages final.pkgs;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      # this is kind of cursed
      inherit (final) overlays;
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

    # On unstable, wait until 25.11 is out
    miru = prev.miru.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or []) ++ [prev.makeWrapper];
      buildCommand = (oldAttrs.buildCommand or "") + ''
        wrapProgram $out/bin/miru --unset ELECTRON_OZONE_PLATFORM_HINT
      '';
    });

    # On unstable, wait until 25.11 is out
    renderdoc = prev.renderdoc.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or []) ++ [prev.makeWrapper];
      preFixup = (oldAttrs.preFixup or "") + ''
        wrapProgram $out/bin/qrenderdoc --set QT_QPA_PLATFORM "wayland;xcb"
      '';
      cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
        (final.lib.cmakeBool "ENABLE_UNSUPPORTED_EXPERIMENTAL_POSSIBLY_BROKEN_WAYLAND" true)
      ];
    });
  };
}
