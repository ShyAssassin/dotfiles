{inputs, pkgs, ...}: rec {
  vrcx-bin = pkgs.callPackage ./vrcx-bin.nix { };
  scopebuddy = pkgs.callPackage ./scopebuddy.nix {};
  easymotion = pkgs.callPackage ./easymotion.nix { inherit inputs; };
}
