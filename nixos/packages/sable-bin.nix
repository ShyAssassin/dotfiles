{
  fetchurl,
  lib, libGL,
  appimageTools,
}: let
  version = "1.22.6";
  pname = "sable-bin";
  src = fetchurl {
    hash = "sha256-DFZZrdwSF/jrlrRQ9gWguDe7AOQVMablEUcD1l3Giic=";
    url = "https://github.com/SableClient/Sable/releases/download/v${version}/Sable-${version}-linux-x86_64.AppImage";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: [ libGL ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/sable.png \
      $out/share/icons/hicolor/128x128/apps/sable.png
    install -m 444 -D ${appimageContents}/sable.desktop \
      $out/share/applications/sable.desktop

    # no clue why wayland is broken, so force x11 for now
    substituteInPlace $out/share/applications/sable.desktop \
      --replace-fail 'Exec=sable %U' 'Exec=${pname} --no-install --ozone-platform-hint=x11 --no-desktop'
  '';

  meta = {
    description = "An almost stable Matrix client.";
    longDescription = ''
      A Matrix client built to enhance the user experience with quality-of-life features, cosmetics, utilities, and sheer usability.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://github.com/SableClient/Sable";
    maintainers = with lib.maintainers; [ ShyAssassin ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    downloadPage = "https://github.com/SableClient/Sable/releases";
  };
}
