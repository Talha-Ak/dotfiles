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
    thunderbird
    # pavucontrol
    # rofi-wayland
  ];

  # services.hyprpaper.enable = true;
  # services.hyprpaper.settings = {
  #   ipc = "on";
  #   splash = false;
  #
  #   preload = ["${config.home.homeDirectory}/nix/wall/wallhaven-2keqwx.png"];
  #
  #   wallpaper = [
  #     ", ${config.home.homeDirectory}/nix/wall/wallhaven-2keqwx.png"
  #   ];
  # };
  #
  # home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/hypr/hyprland.conf";
  # home.file.".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/waybar/config.jsonc";
  # home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/waybar/style.css";
  # home.file.".config/waybar/theme.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/waybar/theme.css";

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";
}
