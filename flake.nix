{
  description = "NixOS configurations and dotfiles";

  inputs = {
    # NixOS
    spicetify.url = "github:Gerg-L/spicetify-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixDarwin
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Hyprland
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # v0.48.1 is super buggy right now under nixos
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.47.2-b";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
  };

  outputs = inputs@{self, nixpkgs, nix-darwin, nixpkgs-darwin, hyprland, split-monitor-workspaces, spicetify}: {
    nixosConfigurations = {
      miyabi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/hosts/miyabi/miyabi.nix
          ./nixos/hosts/miyabi/miyabi-hw.nix

          ./nixos/workspace/dev.nix
          ./nixos/workspace/gaming.nix
          ./nixos/workspace/hyprland.nix

          ./nixos/modules/grub.nix
          ./nixos/modules/nvidia.nix
          ./nixos/modules/spotify.nix
          ./nixos/modules/storage.nix
          ./nixos/modules/syncthing.nix
          ./nixos/modules/virtualization.nix
        ];
      };
      yukime = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/hosts/yukime/yukime.nix
          ./nixos/hosts/yukime/yukime-hw.nix
          ./nixos/hosts/yukime/services/nginx.nix
          ./nixos/hosts/yukime/services/wakapi.nix
          ./nixos/hosts/yukime/services/adguard.nix

          ./nixos/modules/grub.nix
          ./nixos/workspace/dev.nix
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
          ./nixos/hosts/senko.nix
        ];
      };
    };
  };
}
