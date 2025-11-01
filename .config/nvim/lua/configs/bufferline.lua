-- vim.keymap.set('n', '<leader>r', function()
--     vim.bo.buflisted = false
-- end, { desc = 'Remove buffer from Bufferline' })
--
-- vim.keymap.set('n', '<leader>.', function()
--     vim.bo.buflisted = true
-- end, { desc = 'Add buffer to Bufferline' })
--
-- vim.api.nvim_create_autocmd('BufAdd', {
--     callback = function(args)
--         vim.bo[args.buf].buflisted = false
--     end,
-- })
--
-- require('bufferline').setup {
--     options = {
--         mode = 'buffers',
--         numbers = 'none',
--         separator_style = 'thin',
--         diagnostics = 'nvim_lsp',
--         hover = { enabled = false },
--         show_close_icon = false,
--         show_buffer_close_icons = false,
--         always_show_bufferline = true,
--         offsets = {
--             {
--                 filetype = 'NvimTree',
--                 text = '',
--                 highlight = 'Directory',
--                 text_align = 'left',
--             },
--         },
--     },
-- }
--

local harpoon_like_list = {}

-- Add current buffer
vim.keymap.set('n', '<leader>.', function()
    harpoon_like_list[vim.api.nvim_get_current_buf()] = true
end, { desc = 'Add to Bufferline' })

-- Remove current buffer
vim.keymap.set('n', '<leader>r', function()
    harpoon_like_list[vim.api.nvim_get_current_buf()] = nil
end, { desc = 'Remove from Bufferline' })

require('bufferline').setup {
    options = {
        custom_filter = function(bufnr)
            return harpoon_like_list[bufnr] or false
        end,
        mode = 'buffers',
        numbers = 'none',
        show_buffer_close_icons = false,
        separator_style = 'thin',
        always_show_bufferline = true,
        hover = { enabled = false },
        show_close_icon = false,
        diagnostics = false,
        offsets = {
            {
                filetype = 'NvimTree',
                text = '',
                highlight = 'Directory',
                text_align = 'left',
            },
        },
    },
}

-- vim.keymap.set('n', '<leader>j', '<Cmd>BufferLineGoToBuffer 4<CR>')
-- vim.keymap.set('n', '<leader>k', '<Cmd>BufferLineGoToBuffer 3<CR>')
-- vim.keymap.set('n', '<leader>l', '<Cmd>BufferLineGoToBuffer 2<CR>')
-- vim.keymap.set('n', '<leader>p', '<Cmd>BufferLineGoToBuffer 1<CR>')
-- vim.keymap.set('n', '<leader>m', '<Cmd>BufferLineGoToBuffer 5<CR>')
