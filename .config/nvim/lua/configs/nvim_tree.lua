local nvim_tree = require 'nvim-tree'
local map = vim.keymap.set

local M = {}

function M.on_attach(bufnr)
    local api = require 'nvim-tree.api'

    local function opts(desc)
        return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
        }
    end

    -- Apply default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Remove default mapping for 'o'
    vim.keymap.del('n', 'o', { buffer = bufnr })

    -- Set custom mappings
    map('n', 's', api.node.open.edit, opts 'Select')
    map('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
    map('n', 'h', api.node.open.horizontal, opts 'Open: Horizontal Split')
    map('n', 'L', api.node.navigate.sibling.first, opts 'First Sibling')
    map('n', 'K', api.node.navigate.sibling.last, opts 'Last Sibling')

    -- not really used, just placeholders
    map('n', 'J', api.node.open.toggle_group_empty, opts 'Toggle Group Empty')
    map('n', '<C-s>', api.node.run.system, opts 'Run System')
end

local opts = {
    on_attach = M.on_attach,
    ui = {
        confirm = {
            remove = true,
            trash = false,
        },
    },
    git = {
        enable = true, -- show git status icons
        ignore = false, --  hide gitignored files
    },
    trash = {
        cmd = 'gio trash',
        require_confirm = true,
    },
    filters = {
        dotfiles = false,
        custom = {
            '^.git$',
            '^node_modules$',
        },
    },
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    view = {
        side = 'left',
        width = 30,
        preserve_window_proportions = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
        },
        severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
            glyphs = {
                default = '',
                folder = {
                    default = '',
                    empty = '',
                    empty_open = '',
                    open = '',
                    symlink = '',
                },
                git = { unmerged = '' },
            },
        },
    },
}

nvim_tree.setup(opts)
