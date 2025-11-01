-- module caching
if vim.loader then
    vim.loader.enable()
end

-- if not vim.lsp.config then
--     vim.lsp.config = require 'lspconfig'
-- end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        {
            import = 'plugins',
            enabled = not vim.g.vscode,
        },
        {
            import = 'vsc-nvim.plugins',
            enabled = vim.g.vscode,
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'tohtml',
                'getscript',
                'getscriptPlugin',
                'gzip',
                'logipat',
                'netrw',
                'netrwPlugin',
                'netrwSettings',
                'netrwFileHandlers',
                'matchit',
                'tar',
                'tarPlugin',
                'rrhelper',
                'spellfile_plugin',
                'vimball',
                'vimballPlugin',
                'zip',
                'zipPlugin',
                'tutor',
                'rplugin',
                'syntax',
                'synmenu',
                'optwin',
                'compiler',
                'bugreport',
                'ftplugin',
            },
        },
    },
    -- loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
}

local m = 'custom.mappings.'
if not vim.g.vscode then
    require 'custom.highlights'
    require 'custom.autocmds'
    require 'custom.opts'
    require 'custom.status'
    require 'custom.tabs'
    require 'custom.transpose'
    require 'custom.commands'
    vim.schedule(function()
        require(m .. 'keymaps')
        require(m .. 'remap')
    end)
else
    vim.schedule(function()
        require(m .. 'remap')
    end)
end

-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
