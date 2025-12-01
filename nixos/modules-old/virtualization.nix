{config, lib, pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        # ovmf.enable = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  virtualisation.libvirtd.hooks.qemu."win11" = ./win11.sh;
}
