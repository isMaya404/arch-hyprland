local api = vim.api
local M = {}
M.terminals = {}

local function safe_cmd(s)
    pcall(function()
        vim.cmd(s)
    end)
end

function M.toggle(opts)
    local pos = opts.pos or 'sp'
    local id = opts.id or 'default'
    M.terminals[id] = M.terminals[id] or {}
    local data = M.terminals[id]

    if pos == 'buf' then
        if data.buf and api.nvim_buf_is_valid(data.buf) then
            local cur_tab = api.nvim_get_current_tabpage()
            local cur_buf = api.nvim_get_current_buf()

            if data.tab and api.nvim_tabpage_is_valid(data.tab) and cur_tab == data.tab then
                safe_cmd 'tabclose'
                if data.prev_tab and api.nvim_tabpage_is_valid(data.prev_tab) then
                    pcall(api.nvim_set_current_tabpage, data.prev_tab)
                end
                data.tab, data.win, data.prev_tab = nil, nil, nil
                return
            end

            if cur_buf == data.buf then
                if data.tab and api.nvim_tabpage_is_valid(data.tab) then
                    safe_cmd 'tabclose'
                    if data.prev_tab and api.nvim_tabpage_is_valid(data.prev_tab) then
                        pcall(api.nvim_set_current_tabpage, data.prev_tab)
                    end
                else
                    if data.prev_tab and api.nvim_tabpage_is_valid(data.prev_tab) then
                        pcall(api.nvim_set_current_tabpage, data.prev_tab)
                    else
                        safe_cmd 'enew'
                    end
                end
                data.tab, data.win, data.prev_tab = nil, nil, nil
                return
            else
                data.prev_tab = api.nvim_get_current_tabpage()
                if data.tab and api.nvim_tabpage_is_valid(data.tab) then
                    pcall(api.nvim_set_current_tabpage, data.tab)
                    return
                end
                M._open_window(data.buf, pos, id)
                return
            end
        end
    end

    if data.win and api.nvim_win_is_valid(data.win) then
        pcall(api.nvim_win_close, data.win, true)
        data.win = nil
        return
    end

    if data.buf and api.nvim_buf_is_valid(data.buf) then
        M._open_window(data.buf, pos, id)
        return
    end

    local buf = api.nvim_create_buf(false, true)
    data.buf = buf

    vim.bo[buf].filetype = 'terminal'
    vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buf })

    api.nvim_create_autocmd('TermClose', {
        buffer = buf,
        once = true,
        callback = function()
            if data.win and api.nvim_win_is_valid(data.win) then
                pcall(api.nvim_win_close, data.win, true)
            end
            data.win = nil

            if data.tab and api.nvim_tabpage_is_valid(data.tab) then
                if api.nvim_get_current_tabpage() == data.tab then
                    safe_cmd 'tabclose'
                else
                    local ok = pcall(api.nvim_set_current_tabpage, data.tab)
                    if ok then
                        safe_cmd 'tabclose'
                    end
                end
            end

            if data.prev_tab and api.nvim_tabpage_is_valid(data.prev_tab) then
                pcall(api.nvim_set_current_tabpage, data.prev_tab)
            end

            data.tab, data.prev_tab = nil, nil
        end,
    })

    M._open_window(buf, pos, id)
end

function M._open_window(buf, pos, id)
    local win

    if pos == 'vsp' then
        vim.cmd 'vsplit'
        win = api.nvim_get_current_win()
        api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.25))
    elseif pos == 'sp' then
        vim.cmd 'split'
        win = api.nvim_get_current_win()
        api.nvim_win_set_height(win, 15)
    elseif pos == 'float' then
        local w = math.floor(vim.o.columns * 0.85)
        local h = math.floor(vim.o.lines * 0.85)
        local r = math.floor((vim.o.lines - h) / 2)
        local c = math.floor((vim.o.columns - w) / 2)
        win = api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = w,
            height = h,
            row = r,
            col = c,
            style = 'minimal',
            border = 'rounded',
        })
    elseif pos == 'buf' then
        if not M.terminals[id].prev_tab or not api.nvim_tabpage_is_valid(M.terminals[id].prev_tab) then
            M.terminals[id].prev_tab = api.nvim_get_current_tabpage()
        end

        if M.terminals[id].tab and api.nvim_tabpage_is_valid(M.terminals[id].tab) then
            pcall(api.nvim_set_current_tabpage, M.terminals[id].tab)
            win = api.nvim_get_current_win()
            api.nvim_win_set_buf(win, buf)
        else
            M.terminals[id].prev_tab = M.terminals[id].prev_tab or api.nvim_get_current_tabpage()
            vim.cmd 'tabnew'
            local tab = api.nvim_get_current_tabpage()
            win = api.nvim_get_current_win()
            api.nvim_win_set_buf(win, buf)
            M.terminals[id].tab = tab
        end

        if api.nvim_buf_line_count(buf) == 1 and api.nvim_buf_get_lines(buf, 0, 1, false)[1] == '' then
            api.nvim_buf_call(buf, function()
                vim.cmd 'terminal'
            end)
        end
    else
        error(("Invalid pos %q; use 'vsp','sp', 'float', or 'buf'"):format(pos))
    end

    api.nvim_win_set_buf(win, buf)

    if api.nvim_buf_line_count(buf) == 1 and api.nvim_buf_get_lines(buf, 0, 1, false)[1] == '' then
        api.nvim_buf_call(buf, function()
            vim.cmd 'terminal'
        end)
    end

    pcall(api.nvim_buf_set_name, buf, '__BufTerm__')

    vim.cmd 'startinsert'
    M.terminals[id].win = win
end

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term', { clear = true }),
    pattern = '*',
    callback = function(ctx)
        vim.api.nvim_set_option_value('buflisted', false, { buf = ctx.buf })
        vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = ctx.buf })
    end,
})

return M
