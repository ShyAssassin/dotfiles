{
  description = "NixOS configurations and dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {self, nixpkgs, ...} @ inputs: let inherit (self) outputs; in {
    nixosConfigurations = {
      miyabi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/miyabi.nix
          ./nixos/miyabi-hw.nix

          ./nixos/modules/dev.nix
          ./nixos/modules/grub.nix
          ./nixos/modules/nvidia.nix
          ./nixos/modules/storage.nix
          ./nixos/modules/syncthing.nix
        ];
      };
    };
  };
}
