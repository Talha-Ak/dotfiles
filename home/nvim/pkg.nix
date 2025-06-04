{pkgs ? import <nixpkgs> {}}:
with pkgs; let
  bins = [
    git
    gcc
    gnumake
    unzip
    ripgrep
    fd
    tree-sitter
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
    withRuby = true;
    withNodeJs = true;
    withPython3 = true;
    wrapRc = false;
    wrapperArgs = ''--suffix PATH : "${lib.makeBinPath bins}"'';
  }
