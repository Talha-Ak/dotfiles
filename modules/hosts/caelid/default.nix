{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.caelid = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.caelidConfiguration
    ];
  };
}
