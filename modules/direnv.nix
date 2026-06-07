{ self, inputs, ... }:
{
  flake.modules.homeManager.direnv =
    { pkgs, lib, ... }:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
