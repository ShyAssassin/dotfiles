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
    rev = "5a4f7882c77783497a880e8d931433a85b6b6324";
    sha256 = "sha256-IDGwKvZtD/yajPNk1ImEvrUkiolkCBxnmlM5AnWOwHM=";
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
