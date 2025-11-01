local harpoon = require 'harpoon'
_G.max_harpoon_list = 8

harpoon:setup {
    settings = {
        save_on_toggle = true,
        save_on_change = true,
        mark_branch = true,
        excluded_filetypes = { 'harpoon' },
    },
}

-- rev harpoon list
vim.keymap.set('n', '<leader>r', function()
    local list = require('harpoon'):list()
    local items = list.items
    for i = 1, math.floor(#items / 2) do
        items[i], items[#items - i + 1] = items[#items - i + 1], items[i]
    end
    vim.cmd.redrawstatus()
end, { desc = 'Harpoon [R]everse List' })

vim.keymap.set('n', '<leader>.', function()
    local list = harpoon:list()
    if #list.items < _G.max_harpoon_list then
        list:add()
        vim.cmd.redrawstatus()
    end
end, { desc = 'Harpoon add (max 8)' })

vim.keymap.set('n', '<leader>h', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', '<leader>j', function()
    harpoon:list():select(1)
end, { desc = 'Harpoon: Jump to file 1' })

vim.keymap.set('n', '<leader>k', function()
    harpoon:list():select(2)
end, { desc = 'Harpoon: Jump to file 2' })

vim.keymap.set('n', '<leader>l', function()
    harpoon:list():select(3)
end, { desc = 'Harpoon: Jump to file 3' })

vim.keymap.set('n', '<leader>p', function()
    harpoon:list():select(4)
end, { desc = 'Harpoon: Jump to file 4' })
