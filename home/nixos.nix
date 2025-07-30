{
  pkgs,
  config,
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

  home.packages = with pkgs; [
    discord
    foot
    bitwarden-desktop
    dell-command-configure
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = ["--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder"];
  };

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";

  xdg.configFile = pkgs.lib.mkMerge [
    (mkSymlinkedConfig "foot")
  ];
}
