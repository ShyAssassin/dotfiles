{
  description = "NixOS configurations and dotfiles";

  inputs = {
    # NixOS
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.url = "github:Gerg-L/spicetify-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixDarwin
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Hyprland
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # v0.47.2 does not compile under nixos right now
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.47.1";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
  };

  outputs = inputs@{self, nixpkgs, nix-darwin, nixpkgs-darwin, hyprland, split-monitor-workspaces, spicetify}: {
    nixosConfigurations = {
      miyabi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/hosts/miyabi.nix
          ./nixos/hosts/miyabi-hw.nix

          ./nixos/workspace/dev.nix
          ./nixos/workspace/gaming.nix
          ./nixos/workspace/hyprland.nix

          ./nixos/modules/dev.nix
          ./nixos/modules/grub.nix
          ./nixos/modules/nvidia.nix
          ./nixos/modules/spotify.nix
          ./nixos/modules/storage.nix
          ./nixos/modules/syncthing.nix
          ./nixos/modules/virtualization.nix
        ];
      };
    };
    darwinConfigurations = {
      senko = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/hosts/senko.nix
        ];
      };
    };
  };
}
