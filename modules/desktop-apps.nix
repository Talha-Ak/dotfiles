{ self, inputs, ... }:
let
  system = "x86_64-linux";
  unstable = import inputs.unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  flake.modules.homeManager.desktop-apps =
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
      home.packages = with pkgs; [
        unstable.discord
        vesktop
        foot
        bitwarden-desktop
        spotify
        nautilus
        teams-for-linux

        # Screenshot
        grim
        slurp
        satty
      ];

      xdg.configFile = mkSymlinkedConfig "foot";

      home.sessionVariables = {
        SSH_AUTH_SOCK = "/home/talha/.bitwarden-ssh-agent.sock";
      };

      programs.chromium = {
        enable = true;
        package = pkgs.google-chrome;
        commandLineArgs = [
          "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,TouchpadOverscrollHistoryNavigation"
        ];
      };

      programs.thunderbird = {
        enable = true;
        profiles.talha.isDefault = true;
      };
    };
}
