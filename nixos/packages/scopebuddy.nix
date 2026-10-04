{
  jq,
  lib,
  perl,
  xwayland,
  gamescope,
  wlr-randr,
  stdenvNoCC,
  makeWrapper,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  version = "1.5.0";
  pname = "scopebuddy";

  src = fetchFromGitHub {
    rev = version;
    repo = "ScopeBuddy";
    owner = "OpenGamingCollective";
    hash = "sha256-Z4KE6Qs5dcNdoEra1sx69I8EsxztAeVNGgO0ltYz7r0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/scopebuddy $out/bin/scopebuddy
    ln -s $out/bin/scopebuddy $out/bin/scb

    wrapProgram $out/bin/scopebuddy \
      --prefix PATH : ${lib.makeBinPath [
        jq
        perl
        xwayland
        wlr-randr
      ]} \
      --suffix PATH : ${lib.makeBinPath [
        gamescope
      ]}

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.asl20;
    mainProgram = "scopebuddy";
    platforms = platforms.linux;
    description = "ScopeBuddy - gamescope wrapper for Wayland";
    homepage = "https://github.com/OpenGamingCollective/ScopeBuddy";
  };
}
