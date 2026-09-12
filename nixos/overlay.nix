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
    vesktop = (prev.vesktop.override {
      withTTS = false;
      withMiddleClickScroll = true;
    });

    bottles = (prev.bottles.override {
      removeWarningPopup = true;
    });

    # Dont recompile firefox just for their shitty AI
    firefox-unwrapped = (prev.firefox-unwrapped.override {
      onnxruntime = prev.onnxruntime.override {
        cudaSupport = false;
      };
    });

    # Make WayVR work with SteamVR (—ᴗ—)
    wayvr = prev.wayvr.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
        final.makeWrapper
      ];

      postPatch = (old.postPatch or "") + ''
      substituteInPlace dash-frontend/src/util/pactl_wrapper.rs \
        --replace-fail '"pactl"' '"${final.lib.getExe' final.pulseaudio "pactl"}"'
      '';

      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/wayvr \
          --prefix LD_LIBRARY_PATH : ${final.lib.makeLibraryPath (
            (old.buildInputs or []) ++ [
              final.libGL
              final.libuuid
            ]
          )}
      '';
    });

    discord = (prev.discord.override {
      withVencord = true;
      withOpenASAR = true;
    });
  };
}
