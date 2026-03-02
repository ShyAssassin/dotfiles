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
    rev = "15244c5283aa40cb90625c206d15b5ac77889445";
    sha256 = "sha256-vp3/bkS4hjpSVjkh8e6rR/EfNxl4BBQxXk9m8HusCVU=";
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
