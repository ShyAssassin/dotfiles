{
  pkgs,
  inputs,
  fetchFromGitHub,
}: let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in hyprland.stdenv.mkDerivation rec {
  name = pname;
  pname = "hyprland-easymotion";

  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprland-easymotion";
    rev = "2bcecf24e9d9b7db372554d3673ae72d766f3047";
    sha256 = "sha256-fAhIPhKMhB8DrfFUXxRxTOLIAIJ2muqnS/6ZboSP9gg=";
  };

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    hyprland.dev
  ] ++ hyprland.nativeBuildInputs;
  buildInputs = hyprland.buildInputs;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp -r ./hypreasymotion.so "$out/lib/libhyprland-easymotion.so"
    runHook postInstall
  '';
}
