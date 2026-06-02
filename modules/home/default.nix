{
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs-unstable = import inputs.unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  flake.homeConfigurations = {
    "talha@caelid" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs pkgs-unstable;
      };
      modules = [
        ../../home/talha/caelid.nix
      ];
    };

    "talha@limgrave" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        ../../home/talha/limgrave.nix
      ];
    };
  };
}
