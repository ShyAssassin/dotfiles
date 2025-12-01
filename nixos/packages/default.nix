{inputs, pkgs, ...}: rec {
  vrcx-bin = pkgs.callPackage ./vrcx-bin.nix { };
  easymotion = pkgs.callPackage ./easymotion.nix { inherit inputs; };
}
