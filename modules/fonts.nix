{ self, inputs, ... }:
{
  flake.modules.nixos.fonts =
    { pkgs, lib, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.caskaydia-cove
      ];
    };
}
