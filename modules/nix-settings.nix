{ self, inputs, ... }:
{
  flake.modules.nixos.nix-settings =
    { pkgs, lib, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.trusted-users = [ "talha" ];

      nix.optimise.automatic = true;

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 2";
        flake = "/home/talha/nix";
      };

      nixpkgs.config.allowUnfree = true;
    };
}
