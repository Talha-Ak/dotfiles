{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    discord
    alacritty
    bitwarden-desktop
    dell-command-configure
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = ["--enable-features=AcceleratedVideoDecodeLinuxGL"];
  };

  home.shellAliases.srb = "sudo nixos-rebuild switch --flake ~/nix";

  xdg.configFile.alacritty = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/.config/alacritty/";
    recursive = true;
  };
}
