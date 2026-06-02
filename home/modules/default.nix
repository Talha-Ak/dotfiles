{
  pkgs,
  config,
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
    ./nvim.nix
  ];

  home = {
    username = "talha";
    homeDirectory = "/home/talha";

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lh --color=auto";
      la = "ls -lAh --color=auto";

      nfu = "nix flake update --flake ~/nix";
      hrb = "nh home switch";
    };

    packages = with pkgs; [
      git
      vim
      curl
      wget
      btop
    ];
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
  };

  programs.git = {
    enable = true;
    settings.user.name = "Talha Abdulkuddus";
    settings.user.email = "git@talhaak.com";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile = pkgs.lib.mkMerge [
    (mkSymlinkedConfig "yazi")
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
