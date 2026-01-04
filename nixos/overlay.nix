{inputs, ...}: {
  additions = final: prev:
    import ./packages {
      pkgs = prev;
      inherit inputs;
    };

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
    # vesktop = (prev.vesktop.override {
    vesktop = (prev.vesktop.overrideAttrs (oldAttrs: {
      withTTS = false;
      withMiddleClickScroll = true;

      # Can be removed once this lands in unstable
      # https://github.com/NixOS/nixpkgs/issues/476669
      preBuild = ''
        cp -r ${prev.electron.dist} electron-dist
        chmod -R u+w electron-dist
      '';
      buildPhase = ''
        runHook preBuild

        pnpm build
        pnpm exec electron-builder \
          --dir \
          -c.asarUnpack="**/*.node" \
          -c.electronDist="electron-dist" \
          -c.electronVersion=${prev.electron.version}

        runHook postBuild
      '';
    }));

    bottles = (prev.bottles.override {
      removeWarningPopup = true;
    });

    # Dont recompile firefox just for their shitty AI
    firefox-unwrapped = (prev.firefox-unwrapped.override {
      onnxruntime = prev.onnxruntime.override {
        cudaSupport = false;
      };
    });
  };
}
