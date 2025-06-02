return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- event = "VeryLazy",
    init = function()
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    end,
    opts = {
      options = {
        theme = require("catppuccin.utils.lualine")("mocha"),
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
      },
      extensions = { "oil" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    main = "ibl",
    opts = {
      indent = { char = "▏" },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },
}
