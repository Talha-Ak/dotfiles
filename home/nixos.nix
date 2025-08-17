{
  pkgs,
  config,
  inputs,
  ...
}: let
  mkSymlinkedConfig = name: {
    "${name}" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/.config/${name}/";
      recursive = true;
    };
  };
in {
  imports = [
    ./default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";

  home.packages = [
    pkgs.discord
    pkgs.foot
    pkgs.bitwarden-desktop
    pkgs.dell-command-configure
    pkgs.rofi-wayland
    inputs.quickshell.packages.x86_64-linux.default
  ];

  services.hyprpaper.enable = true;
  services.dunst.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = ["--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder"];
  };

  xdg.configFile = pkgs.lib.mkMerge [
    (mkSymlinkedConfig "foot")
    (mkSymlinkedConfig "hypr")
    (mkSymlinkedConfig "uwsm")
    (mkSymlinkedConfig "dunst/dunstrc.d")
    (mkSymlinkedConfig "rofi")
    (mkSymlinkedConfig "quickshell")
  ];
}
