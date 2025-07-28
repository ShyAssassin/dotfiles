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
      url = "github:hyprwm/Hyprland?ref=v0.50.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    overview = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    easymotion = {
      inputs.hyprland.follows = "hyprland";
      # TODO: Use upstream once #23 has merged fixes
      url = "github:ShyAssassin/hyprland-easymotion";
    };

    split-monitor-workspaces = {
      inputs.hyprland.follows = "hyprland";
      url = "github:Duckonaut/split-monitor-workspaces";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, nix-darwin, nixpkgs-darwin,
            hyprland, split-monitor-workspaces, hyprsplit, overview, easymotion,
            spicetify, devnotify
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
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/common.nix

          ./nixos/modules/grub.nix
          ./nixos/workspace/dev.nix
          ./nixos/modules/nvidia.nix
          ./nixos/modules/storage.nix
          ./nixos/modules/syncthing.nix

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
