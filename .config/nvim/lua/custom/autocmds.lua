local function augroup(name)
    return vim.api.nvim_create_augroup('idk_' .. name, { clear = true })
end

-- vim.api.nvim_create_autocmd('BufWritePost', {
--     group = augroup 'source_file',
--     pattern = vim.fn.stdpath 'config' .. '/lua/**/*.lua',
--     callback = function(args)
--         -- Strip the config path and `.lua` extension
--         local module = args.file:match(vim.fn.stdpath 'config' .. '/lua/(.*)%.lua$')
--         if module then
--             module = module:gsub('/', '.') -- convert path to Lua module name
--             package.loaded[module] = nil
--             require(module)
--             vim.notify('Reloaded ' .. module, vim.log.levels.INFO)
--         end
--     end,
-- })

-- Triggers a custom 'User FilePost' event once after UI and file are fully loaded.
-- Useful with nvimlsp-config event trigger and other plugins that behave similarly
-- from: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/autocmds.lua
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('FilePostEvent', { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

        if not vim.g.ui_entered and args.event == 'UIEnter' then
            vim.g.ui_entered = true
        end

        if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
            vim.api.nvim_del_augroup_by_name 'FilePostEvent'

            vim.schedule(function()
                vim.api.nvim_exec_autocmds('FileType', {})

                if vim.g.editorconfig then
                    require('editorconfig').config(args.buf)
                end
            end)
        end
    end,
})

--  highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup 'highlight_yank',
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

------------------- Buffers -------------------

-- hide terminal buffers from buffer list
-- vim.api.nvim_create_autocmd('TermOpen', {
--     group = augroup 'terms',
--     pattern = '*',
--     callback = function(ctx)
--         vim.api.nvim_set_option_value('buflisted', false, { buf = ctx.buf })
--         vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = ctx.buf })
--     end,
-- })

-- restore last cursor position (except commits & only once)
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_loc',
    callback = function(ctx)
        local buf = ctx.buf
        local ft = vim.bo[buf].filetype
        if ft == 'gitcommit' or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lines = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lines then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- remove format options r and o
-- r auto-continue comments on Enter
-- o auto-continue comments on o/O
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup 'format_options',
    pattern = { '*' },
    callback = function()
        vim.opt_local.fo:remove 'o'
        vim.opt_local.fo:remove 'r'
    end,
})

-- max n bufs, auto-delete oldest buf if more than n
vim.api.nvim_create_autocmd('BufAdd', {
    group = augroup 'auto_del_buf',
    callback = function(args)
        local bufnr = args.buf
        if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= '' then
            return
        end

        local max_buf = 50
        local buffers = {}
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[b].buflisted and vim.bo[b].buftype == '' then
                table.insert(buffers, b)
            end
        end

        if #buffers <= max_buf then
            return
        end

        table.sort(buffers)

        for _, b in ipairs(buffers) do
            if b ~= vim.api.nvim_get_current_buf() then
                vim.api.nvim_buf_delete(b, { force = true })
                break
            end
        end
    end,
})

------------------- Comments -------------------

-- treat certain files that does not use strict JSON as jsonc to allow commenting
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = {
        '.prettierrc',
        'tsconfig.json',
        '.eslintrc.json',
        -- other ft's
    },
    callback = function()
        vim.bo.filetype = 'jsonc'
        vim.bo.commentstring = '// %s'
    end,
})

--  commentstring support
local commentstrings = {
    apache = '# %s',
    -- other ft's
}
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'commentstring',
    pattern = vim.tbl_keys(commentstrings),
    callback = function(ctx)
        vim.bo[ctx.buf].commentstring = commentstrings[ctx.match]
    end,
})

----------------- / -------------------

-- improves tailwind perf? https://github.com/hrsh7th/nvim-cmp/issues/1828
vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup 'tailwind_lsp_config',
    pattern = { 'html', 'css', 'scss', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'svelte' },
    callback = function()
        for _, client in pairs(vim.lsp.get_clients()) do
            if client.name == 'tailwindcss' then
                client.server_capabilities.completionProvider.triggerCharacters = { '"', "'", '`', '.', '(', '[', '!', '/', ':' }
            end
        end
    end,
})

-- treat certain template ft's as HTML for syntax highlighting support
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = augroup 'template_html',
--     pattern = { '*.ejs' },
--     callback = function()
--         vim.opt_local.filetype = 'html'
--     end,
-- })

-- apply remaps on man pages (this is just to match my nvim remaps)
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'man_remap',
    pattern = 'man',
    callback = function()
        local opts = { buffer = true, silent = true, noremap = true }

        -- h <-> p, H <-> P
        vim.keymap.set({ 'n', 'v', 'o' }, 'h', 'p', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'H', 'P', opts)

        -- move left/right
        vim.keymap.set({ 'n', 'v', 'o' }, 'j', 'h', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'p', 'l', opts)

        -- move up/down
        vim.keymap.set('o', 'k', 'j', opts)
        vim.keymap.set('o', 'l', 'k', opts)
        vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gj' : 'j'", vim.tbl_extend('force', opts, { expr = true }))
        vim.keymap.set({ 'n', 'x' }, 'l', "v:count == 0 ? 'gk' : 'k'", vim.tbl_extend('force', opts, { expr = true }))

        -- capital bindings
        vim.keymap.set({ 'n', 'v', 'x', 'o' }, 'J', 'H', opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set({ 'n', 'v' }, 'L', 'M', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'P', 'L', opts)

        -- switch b <-> n
        vim.keymap.set({ 'n', 'v', 'o' }, 'b', 'n', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'B', 'N', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'n', 'b', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'N', 'B', opts)

        -- m, o, y swaps
        vim.keymap.set({ 'n', 'v', 'o' }, 'o', 'y', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'O', 'Y', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'm', 'o', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'M', 'O', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'y', 'm', opts)
        vim.keymap.set({ 'n', 'v', 'o' }, 'Y', 'J', opts)
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'neogit',
    pattern = 'NeogitStatus',
    callback = function()
        vim.keymap.set('v', 'k', '<Up>', { buffer = true })
    end,
})
