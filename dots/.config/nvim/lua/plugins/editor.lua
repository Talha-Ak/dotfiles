return {
  -- buffer-like file explorer
  -- TODO: oil-git
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
    opts = {
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Open [E]xplorer" })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
  },

  -- TODO: picker layout
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
    },
    keys = {
      {
        "<C-p>",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sn",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Neovim Config File",
      },
    },
  },

  -- todo highlighter
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    event = { "BufReadPost" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {
      -- Match TODO and TODO(name)
      indent = {
        animate = {
          enabled = false,
        },
      },
      search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
      highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
    },
  },

  -- git diff
  -- TODO: Config
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost" },
    opts = {
      sign_priority = 15, -- higher than todo-comments
    },
  },

  --
  -- {
  --   "tpope/vim-fugitive",
  -- },
  --
  -- { "github/copilot.vim" },
}
