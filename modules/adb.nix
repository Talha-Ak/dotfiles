{ self, inputs, ... }:
{
  flake.modules.nixos.adb =
    { pkgs, lib, ... }:
    {
      programs.adb.enable = true;
      users.users.talha.extraGroups = [ "adbusers" ];
    };
}
