{ self, inputs, ... }:
{
  flake.modules.nixos.flatpak =
    { pkgs, lib, ... }:
    {
      services.flatpak.enable = true;
    };
}
