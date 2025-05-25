{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.kernelParams = ["intel_iommu=on"];

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    # hooks.qemu = {nvidia-detach = ./hook.sh;};
    qemu = {
      swtpm.enable = true;
      ovmf = {
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  # systemd.services.libvirtd = {
  #       path = with pkgs; [ libvirt ];
  #   };

  programs.virt-manager.enable = true;
}
