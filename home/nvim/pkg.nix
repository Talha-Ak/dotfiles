{pkgs ? import <nixpkgs> {}}:
with pkgs; let
  bins = [
    git
    gcc
    gnumake
    unzip
    ripgrep
    fd
    python3
    luajitPackages.luarocks
    lua51Packages.lua

    # lua
    lua-language-server
    stylua

    # nix
    nil
    alejandra
  ];
in
  wrapNeovimUnstable neovim-unwrapped {
    wrapRc = false;
    wrapperArgs = ''--suffix PATH : "${lib.makeBinPath bins}"'';
  }
