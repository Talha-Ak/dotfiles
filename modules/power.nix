{ self, inputs, ... }:
{
  flake.modules.nixos.power =
    { pkgs, lib, ... }:
    {
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;
    };
}
