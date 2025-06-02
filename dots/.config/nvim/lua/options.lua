-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Fonts
vim.g.have_nerd_font = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show mode in command line
vim.opt.showmode = false

-- Sync OS & Vim clipboard
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- If disabled, use "+y and "+p for system clipboard
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)

-- Wrapped lines stay visually indented
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Always draw signcolumn
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Change default split positions
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Highlight cursor line
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Highlight search
vim.opt.hlsearch = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Disable word Wrap
vim.opt.wrap = false

-- Character column marker
vim.opt.colorcolumn = "120"

-- Enable virtual editing for <C-v>
vim.opt.virtualedit = "block"

-- Enable 24-bit colour
vim.opt.termguicolors = true

-- Completion options
vim.opt.completeopt = "menu,menuone,noselect"

-- Completion height
vim.opt.pumheight = 10
