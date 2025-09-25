-- List of LSPs to use.
-- Extra config in /after/lsp/<server>.lua
local servers = {
  mason = {
    "lua_ls",
  },

  manual = {
    "basedpyright",
    "nil_ls",
    "qmlls",
    "texlab",
  },
}

local formatters = {
  mason = {
    lua = { "stylua" },
  },

  manual = {
    nix = { "alejandra" },
    python = { "black", "isort" },
  },
}

-- Lazy load LSP stuff on new buffer... except for when Oil is open.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      local excluded_fts = function()
        local current_filetype = vim.api.nvim_get_option_value("filetype", {})
        local filetypes = { "oil" }
        return vim.list_contains(filetypes, current_filetype)
      end

      if not excluded_fts() then
        vim.cmd("Lazy load nvim-lspconfig mason-lspconfig.nvim mason-tool-installer.nvim")
      end
    end, 250)
  end,
})

return {

  -- Package Mgr for tooling
  {
    "mason-org/mason.nvim",
    lazy = true,
    opts = {
      PATH = "append",
      ui = {
        width = 0.8,
        height = 0.8,
      },
    },
  },

  -- Auto-enables Mason packages, bridges Mason and lspconfig server names.
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = true,
  },

  -- Auto-installs Mason packages (not just servers)
  -- Only enabled if Neovim is not managed by Nix.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    cond = vim.fn.executable("home-manager") == 0,
    opts = function(_, opts)
      table.insert(opts.ensure_installed or {}, {
        function()
          local required_tooling = servers.mason or {}
          local formatters_list = vim.iter(vim.tbl_values(formatters.mason)):flatten():totable()
          return vim.list_extend(required_tooling, formatters_list)
        end,
      })
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      { "j-hui/fidget.nvim" },
      { "folke/snacks.nvim" },
    },
    config = function()
      local all_servers = vim.iter(vim.tbl_values(servers)):flatten():totable()

      if vim.fn.has("wsl") == 0 then
        vim.lsp.enable(all_servers)
      else
        -- https://github.com/neovim/neovim/issues/31506
        -- I hate windows.
        for _, server in pairs(all_servers) do
          local success, server_config = pcall(require, "lspconfig.configs." .. server)
          if success and server_config then
            local cmd = server_config.default_config and server_config.default_config.cmd
            if cmd and type(cmd) == "table" and #cmd > 0 then
              local executable = cmd[1]
              if vim.fn.executable(executable) == 1 then
                vim.lsp.enable(server)
              end
            end
          else
            vim.notify("LSP config for '" .. server .. "' not found. Skipping.", vim.log.levels.WARN)
          end
        end
      end

      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- stylua: ignore
          -- See :h lsp-defualts
          map("grd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")

          -- Highlight references of word under your cursor when idle.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "grf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = function()
      local tables_to_merge = vim.tbl_values(formatters)
      local merged_formatters = vim.tbl_deep_extend("force", {}, unpack(tables_to_merge))
      return {
        formatters_by_ft = merged_formatters,
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style.
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
      }
    end,
  },
}
