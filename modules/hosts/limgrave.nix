{ self, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  flake.homeConfigurations."talha@limgrave" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = with self.modules.homeManager; [
      talha
      shell
      git
      direnv
      yazi
      nvim
      wsl
    ];
  };
}
