{ self, inputs, ... }:
{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
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

          lua-language-server
          stylua

          nil
          nixfmt

          typescript
          typescript-language-server
        ];

        defaultEditor = true;
        vimAlias = true;
      };

      xdg = {
        configFile.nvim = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dots/.config/nvim/";
          recursive = true;
        };

        desktopEntries."nvim" = {
          name = "Neovim";
          genericName = "Text Editor";
          comment = "Edit text files";
          icon = "nvim";
          exec = "nvim %F";
          categories = [ "TerminalEmulator" ];
          terminal = true;
          mimeType = [ "text/plain" ];
        };
      };
    };
}
