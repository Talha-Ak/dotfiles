{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      # url = "github:AvengeMedia/DankMaterialShell?ref=3fb5d5c4f3143b4f41632302f7158fc8a85367bf";
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "unstable";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.caelid = nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/configuration.nix
      ];
    };

    homeConfigurations = {
      "talha@caelid" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/nixos.nix];
      };
      "talha@limgrave" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/wsl.nix];
      };
    };
  };
}
