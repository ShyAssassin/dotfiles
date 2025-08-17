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
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = mkDefault true;
      enable32Bit = mkDefault true;
    };

    services.xserver.videoDrivers = mkDefault [ "nvidia" ];
    nixpkgs.config.cudaSupport = mkDefault cfg.enableCudaSupport;
  };
}
