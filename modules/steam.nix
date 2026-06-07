{ self, inputs, ... }:
{
  flake.modules.nixos.steam =
    { pkgs, lib, ... }:
    {
      programs.steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
}
