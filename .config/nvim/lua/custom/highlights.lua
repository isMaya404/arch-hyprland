local transparent_groups = {
    'Normal',
    'NormalNC',
    'NormalFloat',
    'FloatBorder',
    'Pmenu',
    'TelescopeNormal',
    'TelescopeBorder',
    'SignColumn',
    'StatusLine',
    'TabLine',
    'TabLineFill',
    'TabLineSel',
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = '' })
end
-- vim.api.nvim_set_hl(0, 'Cursor', { bg = '#1e90ff', fg = '#000000' })

vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#303030', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#2E3440' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#555555' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#d19a66' })
vim.api.nvim_set_hl(0, '@number', { fg = '#B48EAD' })

if vim.g.colors_name == 'nord' then
    vim.api.nvim_set_hl(0, 'String', { fg = '#D0D0D0' })
    vim.api.nvim_set_hl(0, '@string', { fg = '#E5E9F0' }) -- treesitter
elseif vim.g.colors_name == 'plain' then
    vim.api.nvim_set_hl(0, '@number', { fg = '#B48EAD' })
    vim.api.nvim_set_hl(0, '@string', { fg = '#E5E9F0' }) -- treesitter
    vim.api.nvim_set_hl(0, '@boolean', { fg = '#E5E9F0' }) -- treesitter
end
