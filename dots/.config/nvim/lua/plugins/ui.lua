--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width)
  return function(str)
    local win_width = vim.o.columns
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len)
    end
    return str
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function()
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    end,
    opts = {
      options = {
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = {
          { "mode", fmt = trunc(80, 1, nil) },
        },
        lualine_b = {
          { "branch" },
          { "diff", fmt = trunc(nil, nil, 60) },
          { "diagnostics" },
        },
        lualine_c = { "filename" },
        lualine_x = {
          { "encoding", fmt = trunc(nil, nil, 80) },
          { "fileformat", fmt = trunc(nil, nil, 80) },
          { "filetype", fmt = trunc(nil, nil, 80) },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "oil" },
    },
  },

  -- line indents
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        animate = {
          enabled = false,
        },
      },
    },
  },

  -- notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      progress = {
        display = {
          done_icon = "",
        },
      },
      notification = {
        window = { winblend = 0 },
      },
    },
  },
}
