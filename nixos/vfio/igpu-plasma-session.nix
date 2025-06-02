{
  config,
  pkgs,
  lib,
  ...
}: let
  plasmaWorkspace = pkgs.kdePackages.plasma-workspace;
  scriptName = "startplasma-wayland-igpu";

  session = pkgs.writeShellScriptBin scriptName ''
    #!${pkgs.runtimeShell}
    export KWIN_DRM_DEVICES="${config.dots.igpuPlasmaSession.igpuDevice}"
    exec ${plasmaWorkspace}/libexec/plasma-dbus-run-session-if-needed ${plasmaWorkspace}/bin/startplasma-wayland
  '';

  desktopFile = pkgs.makeDesktopItem {
    name = "igpu-plasma-wayland";
    desktopName = "Plasma (iGPU)";
    exec = "${session}/bin/${scriptName}";
    type = "Application";
  };

  igpuPlasmaWaylandPkg = pkgs.stdenvNoCC.mkDerivation rec {
    name = "igpu-plasma-wayland";
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/wayland-sessions
      cp ${desktopFile}/share/applications/${name}.desktop $out/share/wayland-sessions/${name}.desktop
    '';

    passthru = {
      providedSessions = [name];
    };
  };
in {
  options.dots.igpuPlasmaSession = {
    enable = lib.mkEnableOption "Plasma Wayland Session forced to iGPU";

    igpuDevice = lib.mkOption {
      type = lib.types.str;
      default = "/dev/dri/card2";
      description = "Value for KWIN_DRM_DEVICES.";
      example = "/dev/dri/card2";
    };
  };

  config = lib.mkIf config.dots.igpuPlasmaSession.enable {
    services.displayManager.sessionPackages = [igpuPlasmaWaylandPkg];
  };
}
