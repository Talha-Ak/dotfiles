{ self, inputs, ... }:
{
  flake.modules.nixos.tailscale =
    { pkgs, lib, ... }:
    {
      services.tailscale.enable = true;
    };
}
