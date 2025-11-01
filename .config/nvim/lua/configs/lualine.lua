local base_theme = require 'lualine.themes.nord'

vim.opt.showmode = false

local dark_bg = '#2e2e2e'
local light_fg = '#e0e0e0'

for _, mode in pairs(base_theme) do
    if mode.b then
        mode.b = vim.tbl_extend('force', {}, mode.b, {
            bg = dark_bg,
            fg = light_fg,
            gui = 'bold',
        })
    end
end

require('lualine').setup {
    options = {
        theme = base_theme,
        globalstatus = true,
    },

    sections = {
        lualine_x = { 'filetype' }, -- override default: remove encoding, fileformat, filetype
    },
}
