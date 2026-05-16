{
  pkgs,
  pkgs-unstable,
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
    inputs.dms.homeModules.dank-material-shell
    inputs.catppuccin.homeModules.catppuccin
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  home.shellAliases.srb = "nh os switch";

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    size = 18;
    name = "Bibata-Modern-Ice";
  };

  home.packages = [
    # Apps
    pkgs-unstable.discord
    pkgs.vesktop
    pkgs.foot
    pkgs.bitwarden-desktop
    pkgs.spotify
    pkgs.nautilus
    pkgs.teams-for-linux

    pkgs.grim
    pkgs.slurp
    pkgs.satty
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/talha/.bitwarden-ssh-agent.sock";
  };

  catppuccin.gtk.icon.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        variant = "mocha";
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;

    settings = {
      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";

      popupTransparency = 0.9;

      runDmsMatugenTemplates = false;

      launcherLogoMode = "os";
      launcherLogoColorOverride = "primary";

      fontFamily = "CaskaydiaCove NF";
      monoFontFamily = "CaskaydiaCove Nerd Font Mono";

      launchPrefix = "uwsm-app";

      animationSpeed = 4;
      customAnimationDuration = 200;

      useAutoLocation = true;
    };

    session = {
      isLightMode = false;
      wallpaperPath = "/home/talha/nix/wall/wallhaven-2keqwx.png";
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = ["--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,TouchpadOverscrollHistoryNavigation"];
  };

  programs.thunderbird = {
    enable = true;
    profiles.talha.isDefault = true;
  };

  xdg.configFile = pkgs.lib.mkMerge [
    (mkSymlinkedConfig "foot")
    (mkSymlinkedConfig "hypr")
    (mkSymlinkedConfig "uwsm")
  ];
}
