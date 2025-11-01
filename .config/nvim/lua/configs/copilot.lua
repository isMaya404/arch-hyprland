require('copilot').setup {
    suggestion = {
        enabled = true,
        auto_trigger = true, -- inline suggestions
        hide_during_completion = true,
        debounce = 150,
        keymap = {
            accept = '<M-l>',
            dismiss = '<C-k>',
            next = '<M-d>',
            prev = '<M-s>',
            accept_word = false,
            accept_line = false,
        },
    },
    panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = '<M-BS>',
            open = '<M-CR>',
        },
        layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
        },
    },
    filetypes = {
        yaml = false,
        markdown = false,
        txt = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        css = false,
        scss = false,
        -- ['.'] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
}
