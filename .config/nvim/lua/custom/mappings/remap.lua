local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Disable
map('c', '<Up>', '<Nop>', opts)
map('c', '<Down>', '<Nop>', opts)

-- Change behavior
-- map({ 'n' }, 'x', '"_x', opts)
-- map({ 'n' }, 'X', '"_X', opts)
-- map({ 'n' }, 's', '"_s', opts)

-- Core Bindings Remap

map('n', 'Q', '@@')

map({ 'n', 'x' }, ';', ':', { noremap = true })
map({ 'n', 'x' }, ':', ',', opts)
map({ 'n', 'x' }, ',', ';', opts)

-- left/right
map({ 'n', 'x', 'o' }, 'j', 'h', opts)
map({ 'n', 'x', 'o' }, 'p', 'l', opts)

-- down/up
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'l', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('o', 'k', 'j', opts)
map('o', 'l', 'k', opts)

-- paste
map({ 'n', 'x', 'o' }, 'h', 'p', opts)
map({ 'n', 'x', 'o' }, 'H', 'P', opts)

-- top/hover/middle/bottom
map({ 'n', 'v', 'x', 'o' }, 'J', 'H', opts)
map('n', 'K', vim.lsp.buf.hover, opts)
map({ 'n', 'x' }, 'L', 'M', opts)
map({ 'n', 'x', 'o' }, 'P', 'L', opts)

-- switch back word and forward/backward next search
map({ 'n', 'x', 'o' }, 'b', 'nzzzv', opts)
map({ 'n', 'x', 'o' }, 'B', 'Nzzzv', opts)
map({ 'n', 'x', 'o' }, 'n', 'b', opts)
map({ 'n', 'x', 'o' }, 'N', 'B', opts)

-- more switches
map({ 'n', 'x', 'o' }, 'o', 'y', opts)
map({ 'n', 'x', 'o' }, 'O', 'y$', opts)
map({ 'n', 'x', 'o' }, 'm', 'o', opts)
map({ 'n', 'x', 'o' }, 'M', 'O', opts)
map({ 'n', 'x', 'o' }, 'y', 'm', opts)
map({ 'n', 'x', 'o' }, 'Y', 'J', opts)
