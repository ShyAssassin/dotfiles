{
  description = "NixOS configurations and dotfiles";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";

    # Modules
    spicetify.url = "github:Gerg-L/spicetify-nix";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";

    # Module Follows
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    spicetify.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Random Applications
    devnotify.inputs.nixpkgs.follows = "nixpkgs";
    devnotify.url = "github:ShyAssassin/devnotify";

    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.55.4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, nixpkgs-darwin,
            nix-darwin, home-manager, spicetify, hyprland, devnotify, ...
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
    packages = forAllSystems (system: import ./nixos/packages {
      inherit inputs outputs;
      pkgs = nixpkgs.legacyPackages.${system};
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell rec {
        buildInputs = with pkgs; [
          git lazygit gh
          nixd bash tmux btop
          quickshell lua python3
          kdePackages.qtdeclarative
          vim neovim nano helix emacs
        ];

        shellHook = ''
          export EDITOR="nvim"
          export NIX_CONFIG="extra-experimental-features = nix-command flakes"
        '';
      };
    });

    darwinConfigurations = {
      senko = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/senko.nix
        ];
      };
    };

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
          # ./nixos/modules-old/syncthing.nix
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
          ./nixos/hosts/yukime/services/matrix.nix
          ./nixos/hosts/yukime/services/wakapi.nix
          ./nixos/hosts/yukime/services/adguard.nix

          # ./nixos/hosts/yukime/services/loki.nix
          # ./nixos/hosts/yukime/services/grafana.nix
          # ./nixos/hosts/yukime/services/promtail.nix
          # ./nixos/hosts/yukime/services/prometheus.nix
        ];
      };

      satsuki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/common.nix

          ./nixos/workspace/dev.nix
          ./nixos/modules-old/grub.nix
          ./nixos/modules-old/storage.nix

          ./nixos/hosts/satsuki/satsuki.nix
          ./nixos/hosts/satsuki/satsuki-hw.nix
        ];
      };
    };
  };
}
