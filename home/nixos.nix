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
    google-chrome
    bitwarden-desktop
    dell-command-configure
  ];

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";
}
