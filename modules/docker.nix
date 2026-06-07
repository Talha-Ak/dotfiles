{ self, inputs, ... }:
{
  flake.modules.nixos.docker =
    { pkgs, lib, ... }:
    {
      virtualisation.docker.enable = true;
      users.users.talha.extraGroups = [ "docker" ];
    };
}
