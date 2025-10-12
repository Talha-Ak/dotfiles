# https://nixos.wiki/wiki/Nvidia
{
  config,
  lib,
  ...
}: {
  # Enable hardware accelerated graphics.
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.udev.extraRules = let
    pciPath = busId: let
      components = lib.drop 1 (lib.splitString ":" busId);
      toHex = i: lib.toLower (lib.toHexString (lib.toInt i));

      bus = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 0));
      device = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 1));
      function = builtins.elemAt components 2; # The function is supposedly a decimal number
    in "${bus}:${device}.${function}";

    pCfg = config.hardware.nvidia.prime;
    igpuId = pciPath (
      if pCfg.intelBusId != ""
      then pCfg.intelBusId
      else pCfg.amdgpuBusId
    );
    dgpuId = pciPath pCfg.nvidiaBusId;
  in ''
    KERNEL=="card*", KERNELS=="0000:${igpuId}", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/igpu1"
    KERNEL=="card*", KERNELS=="0000:${dgpuId}", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/dgpu1"
  '';
}
