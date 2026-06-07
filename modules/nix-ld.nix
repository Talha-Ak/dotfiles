{ self, inputs, ... }:
{
  flake.modules.nixos.nix-ld =
    { pkgs, lib, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = [
          pkgs.stdenv.cc.cc
        ];
      };
    };
}
