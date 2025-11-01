local map = vim.keymap.set
-- local unmap = vim.keymap.del
local opts = { silent = true, noremap = true }

local function map_buffer_cmd(lhs, rhs, desc)
    vim.keymap.set('n', lhs, function()
        if vim.bo.filetype ~= 'NvimTree' then
            vim.cmd(rhs)
        end
    end, { desc = desc, noremap = true, silent = true })
end

map('n', '<leader>mt', '<cmd>silent !ctags -R .<CR>', { desc = 'make tags' })

map('x', '<leader>bp', [["_dP]], { desc = 'blackhole paste' })
map({ 'n', 'v' }, '<leader>bd', [["_d]], { desc = 'blackhole delete' })

map('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'substitute all matching word under cursor in buf' })
map('n', '<leader>s', '<cmd>w<cr>', { desc = 'write' })
map('n', '<leader>q', '<cmd>qa<CR>', { desc = 'quit all' })

-- Toggle spell checker. More useful paired with 'z=' to check spelling suggestions
map('n', '<leader>og', '<cmd>setlocal spell! spelllang=en_us<CR>', { desc = 'orthography' })

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map({ 'n', 'x', 'o' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x', 'o' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

map('n', '<leader><leader>x', '<cmd>source %<CR>')

map('i', '<M-i>', '<ESC>^i', { remap = true, desc = 'move beginning of line' })
map('i', '<M-o>', '<End>', { remap = true, desc = 'move end of line' })
map('i', '<M-d>', '<C-o>dw', { remap = true, desc = 'del word after cursor' })

map({ 'n', 'x' }, '<M-k>', '<C-d>zz', opts)
map({ 'n', 'x' }, '<M-l>', '<C-u>zz', opts)

map('n', '=ap', "ma=ap'a")

map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'copy whole file' })

-- Comment
map('n', '<leader>/', 'gcc', { desc = 'Toggle Comment', remap = true })
map('x', '<leader>/', 'gc', { desc = 'Toggle Comment', remap = true })

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

-- Terminal
-- map({ 'n', 't' }, '<M-i>', function()
--     require('custom.terminal').toggle { pos = 'buf', id = 'bufTerm' }
-- end, { desc = 'toggle buffer term' })

map({ 'n', 't' }, '<M-i>', function()
    require('custom.terminal').toggle { pos = 'float', id = 'floatTerm' }
end, { desc = 'toggle floating term' })

map('t', '<M-n>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

-- Buffers
map_buffer_cmd('<Tab>', 'bnext', 'Next Buffer')
map_buffer_cmd('<S-Tab>', 'bprev', 'Prev Buffer')
map('n', '<leader>,', '<C-^>', { desc = 'Switch to last buffer' })

map('n', '<leader>X', function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local bt = vim.bo[buf].buftype
        if bt == '' or bt == 'acwrite' then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
    end
end, { desc = 'Delete all normal buffers', silent = true })

map('n', '<leader>x', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local listed_buffers = vim.tbl_filter(function(buf)
        return vim.fn.buflisted(buf) == 1
    end, vim.api.nvim_list_bufs())

    local last_buf = listed_buffers[#listed_buffers]
    local next_cmd = current_buf == last_buf and 'bprevious' or 'bnext'
    vim.cmd(next_cmd)
    require('mini.bufremove').delete(current_buf, false)
    -- Built in alternative instead of mini.bufremove:
    -- vim.cmd('bd ' .. current_buf)
end, { desc = 'close current buffer' })

-- Windows

-- unmap default window navigations
map({ 'n', 'x' }, '<C-w>h', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-h>', '<Nop>')
map({ 'n', 'x' }, '<C-w>j', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-j>', '<Nop>')
map({ 'n', 'x' }, '<C-w>k', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-k>', '<Nop>')
map({ 'n', 'x' }, '<C-w>l', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-l>', '<Nop>')

map({ 'n', 'x' }, '<C-j>', '<C-w>h')
map({ 'n', 'x' }, '<C-k>', '<C-w>j')
map({ 'n', 'x' }, '<C-l>', '<C-w>k')
map({ 'n', 'x' }, '<C-p>', '<C-w>l')

map({ 'n', 'x' }, '<leader>wq', '<C-w>q')
map({ 'n', 'x' }, '<leader>wo', '<C-w>o')
map({ 'n', 'x' }, '<leader>wv', '<C-w>v')
map({ 'n', 'x' }, '<leader>wh', '<C-w>s')
map({ 'n', 'x' }, '<leader>we', '<C-w>=')

map({ 'n', 'x' }, '<leader><Down>', ':silent! resize -10<CR>')
map({ 'n', 'x' }, '<leader><Up>', ':silent! resize +10<CR>')
map({ 'n', 'x' }, '<leader><Right>', ':silent! vertical resize +10<CR>')
map({ 'n', 'x' }, '<leader><Left>', ':silent! vertical resize -10<CR>')

map({ 'n', 'x' }, '<C-w>r', '<C-l>', { desc = 'redraw screen' })

-- Script
map({ 'n' }, '<M-m>', ':!tmux-windowizer $(git rev-parse --abbrev-ref HEAD) pnpm dev<CR><CR>')
map({ 'n' }, '<M-1>', ':!tmux-windowizer nn ')
map({ 'n' }, '<M-0>', ':!tmux-windowizer dev:fe pnpm dev:frontend<CR><CR>')
map({ 'n' }, '<M-9>', ':!tmux-windowizer dev:be pnpm dev:backend<CR><CR>')

-- Buffers
map('n', '<Tab>', ':bnext<CR>', opts)
map('n', '<S-Tab>', ':bprevious<CR>', opts)

function CopyAllBuffersToClipboard()
    local all_text = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            table.insert(all_text, table.concat(lines, '\n'))
        end
    end
    local result = table.concat(all_text, '\n\n')
    vim.fn.setreg('+', result) -- Copies to system clipboard
    print 'All buffers copied to clipboard.'
end
map('n', '<leader>CB', '<cmd>lua CopyAllBuffersToClipboard()<CR>', { desc = '[C]opy All [B]uffers To Clipboard' })

-- _G.transpose = {}
--
-- function _G.transpose.words()
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--     local line = vim.api.nvim_get_current_line()
--
--     -- split line into words using vim regex (\S+)
--     local words = {}
--     for w in line:gmatch '%S+' do
--         table.insert(words, w)
--     end
--
--     -- find current word index
--     local char_pos = 0
--     local idx = 0
--     for i, w in ipairs(words) do
--         char_pos = char_pos + #w
--         if char_pos >= col then
--             idx = i
--             break
--         end
--         char_pos = char_pos + 1 -- account for space
--     end
--
--     -- cannot transpose if at first word
--     if idx <= 1 then
--         return
--     end
--
--     -- swap with previous word
--     words[idx], words[idx - 1] = words[idx - 1], words[idx]
--
--     -- reconstruct line
--     local new_line = table.concat(words, ' ')
--     vim.api.nvim_set_current_line(new_line)
--
--     -- restore cursor roughly at the swapped word
--     local new_col = 0
--     for i = 1, idx do
--         new_col = new_col + #words[i] + 1
--     end
--     vim.api.nvim_win_set_cursor(0, { row, new_col - #words[idx] })
-- end

-- mode normal
-- vim.api.nvim_set_keymap('n', '<M-t>', ':lua _G.transpose.words()<CR>', { noremap = true, silent = true })

-- insert mode
-- vim.api.nvim_set_keymap('i', '<M-t>', '<Esc>:lua _G.transpose.words()<CR>a', { noremap = true, silent = true })
--------------------------------------- Plugin Mappings ---------------------------------------
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Nvim-Tree
map('n', '<leader>n', '<Cmd>NvimTreeToggle<CR>', { desc = 'NvimTree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<cr>', { desc = 'NvimTree focus window' })

--  Copilot
local auto_trigger_enabled = true
map('n', '<leader>ai', function()
    auto_trigger_enabled = not auto_trigger_enabled

    if auto_trigger_enabled then
        print 'Copilot auto-suggestion: On'
    else
        print 'Copilot auto-suggestion: Off'
    end

    require('copilot.suggestion').toggle_auto_trigger()
end, { desc = 'Toggle Copilot Auto Suggestion' })

-- Bufferline
-- map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer' })
-- map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Prev Buffer' })

-- Whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })
map('n', '<leader>wk', function()
    vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'whichkey query lookup' })

-- Tailwind Tools
map('n', '<leader>twt', ':TailwindConcealToggle<CR>', { desc = 'Toggle Tailwind Conceal' })
map('n', '<leader>tws', ':TailwindSortSync<CR>', { desc = 'Tailwind Sort (Sync)' })

-- Neotest

map('n', '<leader>ttr', function()
    require('neotest').run.run() -- run nearest test
end, opts)

map('n', '<leader>ttR', function()
    require('neotest').run.run(vim.fn.expand '%') -- run current file
end, opts)

map('n', '<leader>ttA', function()
    require('neotest').run.run { suite = true } -- run all test suite
end, opts)

map('n', '<leader>ttw', function()
    require('neotest').watch.toggle { vim.fn.expand '%' }
end, opts)

map('n', '<leader>tta', function()
    require('neotest').run.attach()
end, opts)

map('n', '<leader>tto', function()
    require('neotest').output_panel.toggle()
end, opts)

map('n', '<leader>tts', function()
    require('neotest').summary.toggle()
end, opts)

map('n', '<leader>ttjn', function()
    require('neotest').jump.next { status = 'failed' }
end, opts)
map('n', '<leader>ttjp', function()
    require('neotest').jump.prev { status = 'failed' }
end, opts)

-- TodoComments
map('n', ']t', function()
    require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

map('n', '[t', function()
    require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Trouble
map('n', '<leader>tl', '<cmd>Trouble loclist toggle focus=true<CR>', { desc = '[T]rouble [L]ocation List' })
map('n', '<leader>tq', '<cmd>Trouble qflist toggle focus=true<CR>', { desc = '[T]rouble [Q]uickfix List' })
map('n', '<leader>tr', '<cmd>Trouble lsp toggle focus=true<CR>', { desc = 'LSP References / Definitions / ... (Trouble)' })
map('n', '<leader>td', '<cmd>Trouble diagnostics toggle focus=true<CR>', { desc = '[T]rouble [D]iagnostics' })
map('n', '<leader>tb', '<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<CR>', { desc = '[T]rouble [B]uffer Diagnostics' })
map('n', '<leader>ts', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = '[T]rouble [S]ymbols' })
-- map('n', '<leader>tf', '<cmd>Trouble lsp toggle focus=true win.position=right<CR>', { desc = 'LSP Definitions / references / ... (Trouble)' })
-- map('n', '<leader>tt', '<cmd>TodoTrouble<CR>', { desc = '[T]rouble [T]odo' }) -- Using telescope for this already

--INFO: These 2 bindings are currently replaced by Trouble.nvim (idk might use again in the future)

-- Add current buffer diagnostics to location list with severity WARN or higher.
-- map('n', '<leader>dl', function()
--   vim.diagnostic.setloclist { severity = { min = vim.diagnostic.severity.WARN } }
-- end, { desc = '[D]iagnostics [L]oclist' })

-- Add all buffer diagnostics to qflist with severity WARN or higher.
-- map('n', '<leader>dq', function()
--   vim.diagnostic.setqflist { severity = { min = vim.diagnostic.severity.WARN } }
-- end, { desc = '[D]iagnostics [Q]uickfix' })

--  Telescope navigations
map('n', '<leader>fl', '<cmd>Telescope find_files<cr>', { desc = 'Find [F]i[L]es' })
map('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = '[F]ind [A]ll Files' })
map('n', '<leader>fp', '<cmd>Telescope buffers<CR>', { desc = '[F]ind Buffers' }) -- NOTE: no mnemonics, fp is just faster than fb is why
map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', { desc = '[F]ind [W]ords' })
map('n', '<leader>fs', '<cmd>Telescope grep_string<cr>', { desc = '[F]ind Current [S]tring' }) -- find string under cursor
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = '[F]ind Curr Buf Fu[ZZ]y' })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = '[F]ind [O]ldfiles' })
map('n', '<leader>fm', '<cmd>Telescope marks<CR>', { desc = '[F]ind [M]arks' })

-- Telescope docs/help/infos
map('n', '<leader>fn', '<cmd>Telescope notify<cr>', { desc = '[F]ind [N]otif History' })
map('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = '[F]ind [K]eymaps' })
map('n', '<leader>fb', '<cmd>Telescope builtin<cr>', { desc = '[F]ind [B]uiltins' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp Page' })
map('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = '[F]ind Telescope Commands' })

-- Quick edit for nvim config
map('n', '<leader>fe', '<cmd>lua require("telescope.builtin").find_files { cwd = vim.fn.stdpath("config") }<cr>', { desc = '[F]ind & [E]dit Nvim Conf' })

-- Telescope git
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'telescope git commits' })
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'telescope git status' })

-- Telescope plugin integrations
map('n', '<leader>fS', '<cmd>Telescope luasnip<CR>', { desc = '[F]ind [S]nippets' })
map('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,BUG,WARN<CR>', { desc = '[F]ind [T]odo' })

-- Telescope x LSP's

map('n', '<leader>LR', '<cmd>LspRestart<cr>')
map('n', '<leader>LI', '<cmd>LspInfo<cr>')

map('n', '<M-w>', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>', { desc = 'Go to [N]ext diagnostic' })
map('n', '<M-W>', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>', { desc = 'Go to [P]rev diagnostic' })
map('n', '<M-n>', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>', { desc = 'Go to [N]ext diagnostic' })
map('n', '<M-N>', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>', { desc = 'Go to [P]rev diagnostic' })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Go to [N]ext diagnostic' })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Go to [P]rev diagnostic' })

map('n', '<leader>df', vim.diagnostic.open_float, { desc = '[D]iagnostic Open Current Line [F]loat' })
map('n', '<leader>dt', function()
    vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = '[D]iagnostics Text [T]oggle' })

map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { desc = '[G]oto [D]efinition' })
map('n', 'grn', vim.lsp.buf.rename, { desc = 'LSP [R]e[n]ame' })
map('n', 'grr', '<cmd>Telescope lsp_references<CR>', { desc = '[L]sp [R]eferences' })
-- map('n', 'grr', vim.lsp.buf.references, { desc = 'LSP [R]eferences' })
map('n', 'grt', '<cmd>Telescope lsp_type_definitions<CR>', { desc = '[G]oto [T]ype Def' })
map('n', 'gri', '<cmd>Telescope lsp_implementations<CR>', { desc = '[G]oto [I]mplementation' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP [G]oto [D]eclaration' })
map('n', 'gra', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

map('n', 'gs', vim.lsp.buf.signature_help, { desc = '[S]ignature Help' })
map('n', 'gS', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Doc [S]ymbols' })
map('n', 'grw', '<cmd>Telescope lsp_workspace_symbols<CR>', { desc = '[W]orkspace Symbols' })
map('n', 'grd', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { desc = '[D]ynamic Workspace Symbols' })

-- Lsp workspace dir
map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace dir' })
map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace dir' })
map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'List workspace folders' })
