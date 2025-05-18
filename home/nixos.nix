{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    discord
  ];

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";
}
