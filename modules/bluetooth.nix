{ self, inputs, ... }:
{
  flake.modules.nixos.bluetooth =
    { pkgs, lib, ... }:
    {
      hardware.bluetooth.enable = true;
    };
}
