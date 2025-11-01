local map = vim.keymap.set
local opts = { silent = true, noremap = true }

map('x', '<leader>p', [["_dP]], { desc = 'blackhole paste' })
map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'blackhole delete' })

map('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'substitute all matching word under cursor' })
map('n', '<leader>s', '<cmd>:w<cr>', { desc = 'write' })

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map({ 'n', 'x', 'o' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x', 'o' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

map('i', '<M-i>', '<ESC>^i', { remap = true, desc = 'move beginning of line' })
map('i', '<M-o>', '<End>', { remap = true, desc = 'move end of line' })
map('i', '<M-d>', '<C-o>dw', { remap = true, desc = 'del word after cursor' })

map({ 'n', 'v' }, '<M-k>', '<C-d>zz', opts)
map({ 'n', 'v' }, '<M-l>', '<C-u>zz', opts)

map('n', '=ap', "ma=ap'a")

-- map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'copy whole file' })

-- Move Line/s Up/Down
map('n', '<M-K>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('i', '<M-K>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('x', '<M-K>', ":move '>+1<CR>gv-gv", opts)
map('n', '<M-L>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<M-L>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('x', '<M-L>', ":move '<-2<CR>gv-gv", opts)

-- Better indent
map('v', '<', '<gv', { remap = true })
map('v', '>', '>gv', { remap = true })

-- Buffers
map('n', '<leader>,', function()
    vim.fn.VSCodeNotify 'workbench.action.openPreviousEditor'
end, { desc = 'Switch to last buffer' })
