{ self, inputs, ... }:
let
  unstable = inputs.unstable.legacyPackages.x86_64-linux;
in
{
  flake.modules.nixos.hyprland =
    { pkgs, lib, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      environment.systemPackages = [
        pkgs.kitty
      ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };

  flake.modules.homeManager.hyprland =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      mkSymlinkedConfig = name: {
        "${name}" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/.config/${name}/";
          recursive = true;
        };
      };
    in
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      xdg.configFile = lib.mkMerge [
        (mkSymlinkedConfig "hypr")
        (mkSymlinkedConfig "uwsm")
      ];

      home.pointerCursor = {
        gtk.enable = true;
        hyprcursor.enable = true;
        package = pkgs.bibata-cursors;
        size = 18;
        name = "Bibata-Modern-Ice";
      };

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        dgop.package = unstable.dgop;
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
    };
}
