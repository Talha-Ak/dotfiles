return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    event = { "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      ensure_installed = { "bash", "lua", "markdown", "regex", "vimdoc" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = { "saghen/blink.download" },
    event = "InsertEnter",
    opts = {
      highlights = { enabled = false },
    },
  },
}
