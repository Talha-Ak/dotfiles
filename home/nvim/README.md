# A (slightly) sane Neovim-Nix configuration

> Shamelessly stolen from [Aylur/dotfiles](https://github.com/Aylur/dotfiles)

Goals:
- Functioning LSPs, formatters, etc.
- Retain my existing lua configration files, *including the package manager*,
  for portability to non-Nix systems.
- Minimise rebuilds (not the Nix way, but practical for me).

[pkg.nix](./pkg.nix) builds the Neovim package with all necessary tools
embedded in Neovim's PATH.

The [lsp.lua](/dots/.config/nvim/lua/plugins/lsp.lua) config file declares and
configures the tools, including a Mason config for non-Nix systems to
auto-install what's needed.

If home-manager is a detected executable, Mason will be skipped and Neovim will
assume that the tools exist in path.

If not, Mason will automatically try to download and install all the tools
needed.

Everything else remains identical to a non-Nix managed Neovim installation.

## Adding an LSP/formatter/other package

1. Add the lsp/tool/package from nixpkgs into [pkg.nix](./pkg.nix).
2. `home-manager switch`
3. Add the corresponding lsp/tool to the table at the top of [lsp.lua](/dots/.config/nvim/lua/plugins/lsp.lua)
   (or wherever you need to reference it).
4. ???
5. Profit.
