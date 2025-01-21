{config, lib, pkgs, ...}:

{
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	hardware.nvidia = {
		open = false;
		nvidiaSettings = false;
		modesetting.enable = true;
		powerManagement.enable = false;
		powerManagement.finegrained = false;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
	services.xserver.videoDrivers = ["nvidia"];
}
