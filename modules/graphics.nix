{ self, inputs, ... }:
{
  flake.modules.nixos.graphics =
    { pkgs, lib, ... }:
    {
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
      };

      hardware.graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-driver
          pkgs.vpl-gpu-rt
        ];
      };
    };
}
