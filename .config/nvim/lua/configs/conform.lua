local conform = require 'conform'

local options = {
    formatters_by_ft = {
        lua = { 'stylua' },
        -- 'stop_after_first' runs the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        pug = { 'prettierd', 'prettier', stop_after_first = true },
        c = { 'clang-format' },
        python = { 'black' },
    },

    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
        else
            return {
                timeout_ms = 500,
                lsp_format = 'fallback',
            }
        end
    end,
}

conform.setup(options)

-- {
--   'stevearc/conform.nvim',
--   event = { 'BufWritePre' },
--   cmd = { 'ConformInfo' },
--   keys = {
--     {
--       '<leader>f',
--       function()
--         require('conform').format { async = true, lsp_format = 'fallback' }
--       end,
--       mode = '',
--       desc = '[F]ormat buffer',
--     },
--   },
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       -- have a well standardized coding style. You can add additional
--       -- languages here or re-enable it for the disabled ones.
--       local disable_filetypes = { c = true, cpp = true }
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       else
--         return {
--           timeout_ms = 500,
--           lsp_format = 'fallback',
--         }
--       end
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- use 'stop_after_first' to run the first available formatter from the list
--       javascript = { 'prettierd', 'prettier', stop_after_first = true },
--       typescripts = { 'prettierd', 'prettier', stop_after_first = true },
--       javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
--       typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
--       html = { 'prettierd', 'prettier', stop_after_first = true },
--       css = { 'prettierd', 'prettier', stop_after_first = true },
--       scss = { 'prettierd', 'prettier', stop_after_first = true },
--     },
--   },
-- },
