local M = {}

M.lazy_file_events = {
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
}

-- LazyFile event to prevent blocking file rendering when loading plugins.
-- See related:
-- https://github.com/LazyVim/LazyVim/blob/dde4a9dcdf49719c67642d09847dbaf7f9c7a156/lua/lazyvim/util/plugin.lua#L72-L103
-- https://github.com/LazyVim/LazyVim/discussions/1583#discussioncomment-7187450
function M.lazy_file()
    -- This autocmd will only trigger when a file was loaded from the cmdline.
    -- It will render the file as quickly as possible.
    vim.api.nvim_create_autocmd("BufReadPost", {
        once = true,
        callback = function(event)
            -- Skip if we already entered vim
            if vim.v.vim_did_enter == 1 then
                return
            end

            -- Try to guess the filetype (may change later on during Neovim startup)
            local ft = vim.filetype.match({ buf = event.buf })
            if ft then
                -- Add treesitter highlights and fallback to syntax
                local lang = vim.treesitter.language.get_lang(ft)
                if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
                    vim.bo[event.buf].syntax = ft
                end

                -- Trigger early redraw
                vim.cmd([[redraw]])
            end
        end,
    })

    vim.api.nvim_create_autocmd(M.lazy_file_events, {
        callback = function(event)
            if vim.g.lazy_file_done == 1 or vim.bo.filetype == "oil" then
                return
            end

            vim.g.lazy_file_done = 1
            vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = true })
        end,
    })

    -- Add support for the LazyFile event
    local Event = require("lazy.core.handler.event")

    Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

return M
