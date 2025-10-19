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
    # TODO: Remove when qs is in nixpkgs stable
    ./quickshell-jank.nix
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  nixpkgs.config.allowUnfree = true;

  home.shellAliases.srb = "nh os switch";

  home.packages = [
    # Apps
    pkgs.discord
    pkgs.foot
    pkgs.bitwarden-desktop
    pkgs.spotify

    # Tools
    pkgs.dell-command-configure
    pkgs.rofi-wayland
    pkgs.grim
    pkgs.slurp
    pkgs.satty
  ];

  services.dunst.enable = true;

  programs.dankMaterialShell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    default.session = {
      wallpaperPath = "~/nix/wall/wallhaven-2keqwx.png";
      wallpaperLastPath = "~/nix/wall";
      isLightMode = false;
      launchPrefix = "uwsm-app";
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = ["--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,TouchpadOverscrollHistoryNavigation"];
  };

  xdg.configFile = pkgs.lib.mkMerge [
    (mkSymlinkedConfig "foot")
    (mkSymlinkedConfig "hypr")
    (mkSymlinkedConfig "uwsm")
    (mkSymlinkedConfig "dunst/dunstrc.d")
    (mkSymlinkedConfig "rofi")
  ];
}
