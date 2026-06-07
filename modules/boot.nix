{ self, inputs, ... }:
{
  flake.modules.nixos.boot =
    { pkgs, lib, ... }:
    {
      boot.loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "max";
        efi.canTouchEfiVariables = true;
      };

      boot.plymouth.enable = true;
      boot.plymouth.extraConfig = "DeviceScale=1";
      boot.initrd.verbose = false;
      boot.consoleLogLevel = 3;
      boot.kernelParams = [
        "quiet"
        "udev.log_level=3"
      ];
    };
}
