{ self, inputs, ... }:
{
  flake.modules.homeManager.yazi =
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
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
      };

      xdg.configFile = lib.mkMerge [
        (mkSymlinkedConfig "yazi")
      ];
    };
}
