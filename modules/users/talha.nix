{ self, inputs, ... }:
{
  flake.modules.nixos.talha =
    { pkgs, lib, ... }:
    {
      users.users.talha = {
        isNormalUser = true;
        description = "Talha Abdulkuddus";
        extraGroups = [
          "wheel"
        ];
      };
    };

  flake.modules.homeManager.talha =
    { pkgs, ... }:
    {
      home = {
        username = "talha";
        homeDirectory = "/home/talha";
        stateVersion = "24.11";
      };

      programs.home-manager.enable = true;

      nixpkgs.config.allowUnfree = true;
    };
}
