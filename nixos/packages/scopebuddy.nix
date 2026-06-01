{
  jq,
  lib,
  perl,
  gamescope,
  wlr-randr,
  stdenvNoCC,
  makeWrapper,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  version = "1.4.0";
  pname = "scopebuddy";

  src = fetchFromGitHub {
    rev = version;
    repo = "ScopeBuddy";
    owner = "OpenGamingCollective";
    hash = "sha256-1n1lZidbtDV9Lm8QKd1s35bOS6Uh8sI3KtBJZ+FwdxQ=";
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
        gamescope
        wlr-randr
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
