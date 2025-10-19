# (GPU) PCI passthrough via OVMF
# Intel CPU and NVIDIA GPU
#
# Refs:
# - Obligatory random reddit thread
#   https://old.reddit.com/r/VFIO/comments/1j9v59m/is_it_possible_to_alternate_between_2_gpus/mi1igi6/
# - https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
# - https://github.com/bryansteiner/gpu-passthrough-tutorial
# - https://looking-glass.io/docs/B7/ivshmem_kvmfr/
#
# TODO:
# - Config for enabling/disabling
# - OWNER in udev conf and users.users.<name> should pull from config, not hardcoded.
# - Maybe make this dependent on NVIDIA being loaded.
{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./igpu-plasma-session.nix
  ];

  # Add iGPU only plasma session to display manager.
  dots.igpuPlasmaSession = {
    enable = false;
    igpuDevice = "/dev/dri/card2";
  };

  # Enable IOMMU support on Intel CPUS.
  boot.kernelParams = ["intel_iommu=on"];

  # Load Looking Glass KVMFR kernel module for 2560x1600 resolution
  boot.extraModulePackages = with config.boot.kernelPackages; [kvmfr];
  boot.extraModprobeConfig = "options kvmfr static_size_mb=64";
  boot.kernelModules = ["kvmfr"];

  # Group (for skipping sudo) and Looking Glass.
  users.users.talha = {
    extraGroups = ["libvirtd"];
    packages = with pkgs; [looking-glass-client];
  };

  # Configure kvmfr device to allow user access.
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="talha", GROUP="kvm", MODE="0660"
  '';

  # Allow for USB devices to be passed into VMs.
  virtualisation.spiceUSBRedirection.enable = true;

  # Virtualisation Management Daemon
  virtualisation.libvirtd = {
    enable = true;

    hooks.qemu = {
      # Hook for disabling/enabling host NVIDIA drivers.
      nvidia-detach = ./hook.sh;
    };

    qemu = {
      # TPM emulator.
      swtpm.enable = true;

      # UEFI firmware with TPM/Secure Boot (for Win 11).
      ovmf.packages = [
        (pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd
      ];

      # QEMU conf to allow KVMFR device access.
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

  # GUI for libvirtd.
  programs.virt-manager.enable = true;
}
