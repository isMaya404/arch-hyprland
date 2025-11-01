local o = vim.opt

-- key delays (too low will break bindings)
o.timeoutlen = 400 -- 1000 is default (for mappings)
o.ttimeoutlen = 0 -- 50 is default (for key codes)

o.termguicolors = true
o.swapfile = false
o.list = false
o.mouse = 'a'
o.number = true
o.relativenumber = true
o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
o.cursorline = true -- to highlight current line number (cursorline itself is transparent using hl groups in './highlights.lua')
o.cursorcolumn = false
o.autowrite = true -- automatically write buffers when running certain commands (but not on every switch)
o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals'
o.completeopt = 'menu,menuone,noinsert'
o.winblend = 0
-- o.guicursor = 'n-v-c-i-r-ci:block-blinkon3-blinkoff3-blinkwait1'
o.guicursor =
    'n-v-c:block-blinkon3-blinkoff3-blinkwait1,i:ver20-blinkon3-blinkoff3-blinkwait1,r:block-blinkon3-blinkoff3-blinkwait1,ci:block-blinkon3-blinkoff3-blinkwait1'
-- o.guicursor = {
--     'n-v-c:block-blinkon3-blinkoff3-blinkwait1',
--     'i-ci-r-cr-t:block-blinkon3-blinkoff3-blinkwait1-Cursor/lCursor',
-- }

o.foldenable = true
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldcolumn = '0' -- fold col width, 0 to hide
o.foldlevel = 99 -- Prevent auto-closing of folds
o.foldlevelstart = 99 -- Start unfolded
o.fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
}
o.formatoptions = 'jcqlnt'
o.grepformat = '%f:%l:%c:%m'
o.grepprg = 'rg --vimgrep'
o.inccommand = 'nosplit' -- preview incremental substitute
o.jumpoptions = 'view'
o.laststatus = 3 -- global statusline
o.linebreak = true -- Wrap lines at convenient points
o.pumblend = 10 -- popup blend
o.pumheight = 10 -- maximum number of entries in a popup
o.ruler = false -- disable the default ruler
o.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
o.shortmess:append { W = true, I = true, c = true, C = true }
o.scrolloff = 6
o.sidescrolloff = 8
o.signcolumn = 'yes'
o.ignorecase = true
o.smartcase = true
o.smartindent = true
o.spelllang = { 'en' }
o.splitbelow = true
o.splitright = true
o.splitkeep = 'screen'
o.expandtab = true -- use spaces instead of a real tab character (\t).
o.shiftround = true
o.shiftwidth = 2 -- number of spaces to use for each level of indentation when autoindenting or using >> / <<.
o.softtabstop = 2 -- how many spaces <Tab> or <BS> counts for while typing/deleting.
o.tabstop = 2 -- how many spaces a literal <Tab> character *displays as* when the file actually has a "\t" char inside.
o.undofile = true
o.undolevels = 5000
o.undodir = vim.fn.stdpath 'state' .. '/undo'
o.updatetime = 200 -- trigger CursorHold
o.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
o.wildmode = 'longest:full,full' -- command-line completion mode
o.winminwidth = 5
o.wrap = true

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
