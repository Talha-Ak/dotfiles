{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
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

    defaultEditor = true;
    vimAlias = true;
  };

  xdg = {
    configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/.config/nvim/";
    configFile.nvim.recursive = true;

    desktopEntries."nvim" = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      icon = "nvim";
      exec = "nvim %F";
      categories = ["TerminalEmulator"];
      terminal = true;
      mimeType = ["text/plain"];
    };
  };
}
