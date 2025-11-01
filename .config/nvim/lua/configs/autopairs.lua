local M = {}

M.config = {
    active = true,
    map_char = {
        all = '(',
        tex = '{',
    },
    enable_check_bracket_line = false,
    check_ts = true,
    ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        java = false,
    },
    disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
    disable_in_macro = false,
    disable_in_visualblock = false,
    disable_in_replace_mode = true,
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
    enable_moveright = true,
    enable_afterquote = true,
    enable_abbr = false,
    break_undo = true,
    map_cr = true,
    map_bs = true,
    map_c_w = false,
    map_c_h = false,
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0,
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
    },
}

M.setup = function()
    local ok, autopairs = pcall(require, 'nvim-autopairs')
    if not ok then
        return
    end

    autopairs.setup(M.config)

    pcall(function()
        local cmp = require 'cmp'
        local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end)
end

return M
