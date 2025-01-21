# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
	nixpkgs.config.allowUnfree = true;

	networking.hostName = "miyabi";

	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	# Set your time zone.
	time.timeZone = "Africa/Johannesburg";

	# Select internationalisation properties.
	# i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#   font = "Lat2-Terminus16";
	#   keyMap = "us";
	#   useXkbConfig = true; # use xkb.options in tty.
	# };

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver.xkb.layout = "za";
	services.xserver.xkb.options = "";

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	services.pipewire = {
		enable = true;
		jack.enable = true;
		alsa.enable = true;
		pulse.enable = true;
		alsa.support32Bit = true;
		wireplumber.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.libinput.enable = true;
	programs.steam.enable = true;
	users.users.assassin = {
		isNormalUser = true;
		description = "[Assassin]";
		extraGroups = ["wheel" "networkmanager"];
		packages = with pkgs; [
			github-desktop
			rust-analyzer
			mangohud
			vesktop
			vscode
		];
	};

	programs.firefox.enable = true;
	nix.settings.experimental-features = "nix-command flakes";
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		git
		btop
		neovim
		rustup
		neofetch
	];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.11"; # Did you read the comment?
}

