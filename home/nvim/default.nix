{
  config,
  pkgs,
  ...
}: let
  nvim = import ./pkg.nix {inherit pkgs;};
in {
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

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases.vim = "nvim";

  home.packages = [nvim];
}
