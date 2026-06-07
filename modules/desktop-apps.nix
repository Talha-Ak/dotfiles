{ self, inputs, ... }:
let
  unstable = inputs.unstable.legacyPackages.x86_64-linux;
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
