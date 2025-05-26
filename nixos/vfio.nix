{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.extraModprobeConfig = "options kvmfr static_size_mb=64";
  boot.kernelModules = ["kvmfr"];
  boot.kernelParams = ["intel_iommu=on"];

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    hooks.qemu = {nvidia-detach = ./hook.sh;};
    qemu = {
      ovmf = {
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
      swtpm.enable = true;
      verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
          "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
          "/dev/kvmfr0"
        ]
      '';
    };
  };
  # systemd.services.libvirtd = {
  #       path = with pkgs; [ libvirt ];
  #   };

  programs.virt-manager.enable = true;
}
