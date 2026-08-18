{ config, lib, pkgs, ... }: with lib; let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable NVIDIA graphics support";
    };
    enableCudaSupport = mkOption {
      default = true;
      type = types.bool;
      description = "Enable CUDA support (increases build times)";
    };
    enableCudaCache = mkOption {
      default = true;
      type = types.bool;
      description = "Enable cuda binary cache (download prebuilt binaries with cuda support)";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = mkDefault true;
      enable32Bit = mkDefault true;
    };

    services.xserver.videoDrivers = mkDefault [ "nvidia" ];
    nixpkgs.config.cudaSupport = mkDefault cfg.enableCudaSupport;

    nix.settings = mkIf cfg.enableCudaCache {
      substituters = [
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
