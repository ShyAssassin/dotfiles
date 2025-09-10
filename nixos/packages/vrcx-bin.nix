{
  fetchurl,
  appimageTools,
  lib, icu, libGL,
  dotnet-runtime_9,
}: let
  pname = "vrcx-bin";
  version = "2025.09.10";
  filename = builtins.replaceStrings [ "." ] [ "" ] version;
  src = fetchurl {
    hash = "sha256-WyoMJJG6Wrilh9fzJDEmGjRoI1oCz7C/0/k8+O7srZA=";
    url = "https://github.com/vrcx-team/VRCX/releases/download/v${version}/VRCX_${filename}_x64.AppImage";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs = pkgs: [ icu dotnet-runtime_9 ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/vrcx.desktop \
      $out/share/applications/VRCX.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/vrcx.png \
      $out/share/icons/hicolor/512x512/apps/VRCX.png

    # no clue why wayland is broken, so force x11 for now
    substituteInPlace $out/share/applications/VRCX.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname} --no-install --ozone-platform-hint=x11 --no-desktop'
  '';

  meta = {
    description = "Friendship management tool for VRChat";
    longDescription = ''
      VRCX is an assistant/companion application for VRChat that provides information about and helps you accomplish various things
      related to VRChat in a more convenient fashion than relying on the plain VRChat client (desktop or VR), or website alone.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://github.com/vrcx-team/VRCX";
    maintainers = with lib.maintainers; [ ShyAssassin ];
    downloadPage = "https://github.com/vrcx-team/VRCX/releases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
