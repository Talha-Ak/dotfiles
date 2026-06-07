{ self, inputs, ... }:
{
  flake.modules.nixos.printing =
    { pkgs, lib, ... }:
    {
      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };

      services.printing = {
        enable = true;
        drivers = [
          pkgs.cups-filters
          pkgs.cups-browsed
        ];
      };
    };
}
