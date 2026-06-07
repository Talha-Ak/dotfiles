{ self, inputs, ... }:
{
  flake.modules.nixos.networking =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      networking.networkmanager.enable = true;
      networking.networkmanager.wifi.backend = "iwd";

      users.users.talha.extraGroups = [ "networkmanager" ];
    };
}
