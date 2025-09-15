{
  description = "NixOS configurations and dotfiles";

  inputs = {
    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # NixDarwin
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Random Applications
    devnotify.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.url = "github:Gerg-L/spicetify-nix";
    devnotify.url = "github:ShyAssassin/devnotify";
    spicetify.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Hyprland stuff
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.51.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    easymotion = {
      inputs.hyprland.follows = "hyprland";
      url = "github:zakk4223/hyprland-easymotion";
    };

    split-monitor-workspaces = {
      inputs.hyprland.follows = "hyprland";
      url = "github:Duckonaut/split-monitor-workspaces";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, nix-darwin, nixpkgs-darwin,
            hyprland, split-monitor-workspaces, hyprsplit, easymotion,
            spicetify, devnotify, ...
  }@inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixosModules = import ./nixos/modules/default.nix;
    overlays = import ./nixos/overlay.nix {inherit inputs outputs;};
    packages = forAllSystems (system: import ./nixos/packages nixpkgs.legacyPackages.${system});

    nixosConfigurations = {
      miyabi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/common.nix

          ./nixos/hosts/miyabi/miyabi.nix
          ./nixos/hosts/miyabi/miyabi-hw.nix

          ./nixos/workspace/dev.nix
          ./nixos/workspace/gaming.nix
          ./nixos/workspace/hyprland.nix
          ./nixos/workspace/streaming.nix

          ./nixos/modules-old/grub.nix
          ./nixos/modules-old/spotify.nix
          ./nixos/modules-old/storage.nix
          ./nixos/modules-old/syncthing.nix
          ./nixos/modules-old/virtualization.nix
        ];
      };
      yukime = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/common.nix

          ./nixos/workspace/dev.nix
          ./nixos/modules-old/grub.nix
          ./nixos/modules-old/storage.nix
          ./nixos/modules-old/syncthing.nix

          ./nixos/hosts/yukime/yukime.nix
          ./nixos/hosts/yukime/yukime-hw.nix
          ./nixos/hosts/yukime/services/nginx.nix
          ./nixos/hosts/yukime/services/wakapi.nix
          ./nixos/hosts/yukime/services/adguard.nix
        ];
      };
    };
    darwinConfigurations = {
      senko = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/senko.nix
        ];
      };
    };
  };
}
