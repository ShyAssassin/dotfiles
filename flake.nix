{
  description = "NixOS configurations and dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{self, nixpkgs, nix-darwin, nixpkgs-darwin}: {
    nixosConfigurations = {
      miyabi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
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
    darwinConfigurations = {
      senko = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/senko.nix
        ];
      };
    };
  };
}
