{ self, inputs, ... }:
{
  flake.modules.nixos.nvidia-optimus =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      programs.gpu-screen-recorder.enable = true;
      environment.systemPackages = [
        pkgs.gpu-screen-recorder-gtk
      ];

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

        open = true;

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

      services.udev.extraRules =
        let
          pciPath =
            busId:
            let
              components = lib.drop 1 (lib.splitString ":" busId);
              toHex = i: lib.toLower (lib.toHexString (lib.toInt i));

              bus = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 0));
              device = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 1));
              function = builtins.elemAt components 2;
            in
            "${bus}:${device}.${function}";

          pCfg = config.hardware.nvidia.prime;
          igpuId = pciPath (if pCfg.intelBusId != "" then pCfg.intelBusId else pCfg.amdgpuBusId);
          dgpuId = pciPath pCfg.nvidiaBusId;
        in
        ''
          KERNEL=="card*", KERNELS=="0000:${igpuId}", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/igpu1"
          KERNEL=="card*", KERNELS=="0000:${dgpuId}", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/dgpu1"
        '';
    };
}
