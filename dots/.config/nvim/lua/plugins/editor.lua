return {

  -- buffer-like file explorer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
    end,
    vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Open [E]xplorer" }),
  },

  -- fuzzy finder
  {
    -- TODO: LazyVim has a fn that detects .git and changes cmd between git_files and find_files
    -- https://github.com/LazyVim/LazyVim/blob/dde4a9dcdf49719c67642d09847dbaf7f9c7a156/lua/lazyvim/plugins/extras/editor/telescope.lua
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "nvim-tree/nvim-web-devicons",
        enabled = vim.g.have_nerd_font,
      },
    },
    cmd = "Telescope",
        -- stylua: ignore
        keys = {
            { "<C-p>",      function() require("telescope.builtin").git_files()  end, desc = "Find git files" },
            { "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "Find files" },
            { "<leader>sg", function() require("telescope.builtin").live_grep()  end, desc = "Grep" },
        },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },

  -- todo highlighter
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
  },

  -- git diff
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
  },

  {
    "tpope/vim-fugitive",
    event = "LazyFile",
  },

  {
    "nmac427/guess-indent.nvim",
    event = "LazyFile",
  },

  { "github/copilot.vim" },
}
