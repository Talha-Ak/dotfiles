{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
  ];

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";
}
