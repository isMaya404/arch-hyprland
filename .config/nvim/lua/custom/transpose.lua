-- Transpose Words On Current Line
--
-- local M = {}
--
-- local function get_words_and_starts(line)
--     local words, starts = {}, {}
--     for s, w in line:gmatch '()(%S+)' do
--         table.insert(words, w)
--         table.insert(starts, s) -- 1-based byte index of start
--     end
--     return words, starts
-- end
--
-- local function reconstruct_from_words(words)
--     -- Simple reconstruction: join with single spaces (keeps behavior like your prior fn)
--     return table.concat(words, ' ')
-- end
--
-- -- transpose word at/after cursor with the following word
-- function M.transpose_forward()
--     local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
--     local col = col0 + 1 -- convert to 1-based byte index for comparisons
--     local line = vim.api.nvim_get_current_line()
--
--     local words, starts = get_words_and_starts(line)
--     if #words < 2 then
--         return
--     end
--
--     -- find first word at-or-after cursor
--     local idx = nil
--     for i = 1, #words do
--         local s = starts[i]
--         local e = s + #words[i] - 1
--         if col >= s and col <= e then
--             idx = i
--             break
--         end
--         if col < s then
--             idx = i
--             break
--         end
--     end
--
--     if not idx or idx >= #words then
--         return
--     end -- nothing to swap with
--     words[idx], words[idx + 1] = words[idx + 1], words[idx]
--
--     vim.api.nvim_set_current_line(reconstruct_from_words(words))
--
--     -- restore cursor to start of the (originally next) word (approx)
--     local new_start = starts[idx + 1] or col
--     vim.api.nvim_win_set_cursor(0, { row, new_start - 1 })
-- end
--
-- -- transpose the previous word with the word at/after cursor (i.e. swap previous and current/next)
-- function M.transpose_backward()
--     local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
--     local col = col0 + 1
--     local line = vim.api.nvim_get_current_line()
--
--     local words, starts = get_words_and_starts(line)
--     if #words < 2 then
--         return
--     end
--
--     -- find previous word index: the last word whose end is < col, OR if cursor is inside a word treat that word as the "second" and pick its previous
--     local prev_idx = nil
--     for i = 1, #words do
--         local s = starts[i]
--         local e = s + #words[i] - 1
--         if e < col then
--             prev_idx = i
--         else
--             break
--         end
--     end
--
--     -- if cursor is inside a word and prev_idx is nil, then treat current word as second -> prev_idx = current_index - 1
--     if not prev_idx then
--         -- find word at-or-after to get current index
--         local cur_idx = nil
--         for i = 1, #words do
--             local s = starts[i]
--             local e = s + #words[i] - 1
--             if col >= s and col <= e then
--                 cur_idx = i
--                 break
--             end
--             if col < s then
--                 cur_idx = i
--                 break
--             end
--         end
--         if cur_idx and cur_idx > 1 then
--             prev_idx = cur_idx - 1
--         end
--     end
--
--     if not prev_idx or prev_idx >= #words then
--         return
--     end
--     -- swap prev_idx and prev_idx+1
--     words[prev_idx], words[prev_idx + 1] = words[prev_idx + 1], words[prev_idx]
--
--     vim.api.nvim_set_current_line(reconstruct_from_words(words))
--
--     -- restore cursor to start of the (originally previous) word (approx)
--     local new_start = starts[prev_idx] or col
--     vim.api.nvim_win_set_cursor(0, { row, new_start - 1 })
-- end
--
-- vim.keymap.set('n', '<M-t>', function()
--     M.transpose_forward()
-- end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<M-T>', function()
--     M.transpose_backward()
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set('i', '<M-t>', function()
--     -- exit insert, call forward, re-enter insert
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
--     M.transpose_forward()
--     vim.api.nvim_feedkeys('a', 'n', true)
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set('i', '<M-T>', function()
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
--     M.transpose_backward()
--     vim.api.nvim_feedkeys('a', 'n', true)
-- end, { noremap = true, silent = true })
--
-- return M
--
-- lua/transpose_emacs.lua
-- Emacs-like transpose-words for Neovim (approximate, but follows Emacs cursor semantics)
local M = {}

-- Get first match of "word" (alphanumeric + underscore) on line r starting at byte column >= start_byte.
-- Returns { row = <1-based>, s = <1-based byte start>, e = <1-based byte end>, text = <string> }
local function find_next_word_from_line(line, start_byte, row)
    for s, w in line:gmatch '()([%w_]+)' do
        local e = s + #w - 1
        if e >= start_byte then
            return { row = row, s = s, e = e, text = w }
        end
    end
    return nil
end

-- Search forward from (row, start_byte) inclusive for the next word (can be on later lines)
local function find_next_word(buf, row, start_byte)
    local linecount = vim.api.nvim_buf_line_count(buf)
    for r = row, linecount do
        local line = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1] or ''
        local start_at = (r == row) and start_byte or 1
        local found = find_next_word_from_line(line, start_at, r)
        if found then
            return found
        end
    end
    return nil
end

-- Search backward from (row, start_byte) to find the previous word strictly before the cursor
-- or the last word on previous lines.
local function find_prev_word(buf, row, start_byte)
    for r = row, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1] or ''
        local last = nil
        for s, w in line:gmatch '()([%w_]+)' do
            local e = s + #w - 1
            if r == row then
                if e < start_byte then
                    last = { row = r, s = s, e = e, text = w }
                elseif s <= start_byte and e >= start_byte then
                    -- cursor inside this word — previous is whatever we found earlier (last), break
                    break
                else
                    break
                end
            else
                -- earlier line: keep last occurrence on that line
                last = { row = r, s = s, e = e, text = w }
            end
        end
        if last then
            return last
        end
    end
    return nil
end

-- Replace region (row, s..e) where s,e are 1-based byte indices with newtext
local function replace_region(buf, row, s, e, newtext)
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ''
    local prefix = line:sub(1, s - 1)
    local suffix = line:sub(e + 1, -1)
    local newline = prefix .. newtext .. suffix
    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { newline })
end

-- Emacs semantics:
-- If point is inside a word -> that word is the "second" (right-hand) word to swap.
-- Else -> take first word AFTER point as the second.
-- Then swap the previous word (left) with that second word (right).
function M.transpose_words_emacs()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0) -- {row, col0}; col0 is 0-based byte index
    local row, col0 = pos[1], pos[2]
    local col_byte = col0 + 1 -- convert to 1-based byte index

    -- Determine the "second" word (the one at/after point if not inside a word,
    -- or the word containing point if inside).
    local second = find_next_word(buf, row, col_byte)
    -- If the cursor is inside a word, find_next_word will return that same word (since e >= col_byte)
    -- If no word after cursor, nothing to do.
    if not second then
        return
    end

    -- Find the "first" word (the previous word before that second word).
    -- If cursor was inside a word, we want the previous word BEFORE that.
    -- We'll search backward from the start of 'second'.
    local first = find_prev_word(buf, second.row, second.s)
    if not first then
        return
    end

    -- If both words are on the same line, rebuild preserving the between-text.
    if first.row == second.row then
        local line = vim.api.nvim_buf_get_lines(buf, first.row - 1, first.row, false)[1] or ''
        local a = line:sub(1, first.s - 1)
        local between = line:sub(first.e + 1, second.s - 1)
        local after = line:sub(second.e + 1, -1)
        local new = a .. second.text .. between .. first.text .. after
        vim.api.nvim_buf_set_lines(buf, first.row - 1, first.row, false, { new })
    else
        -- Cross-line swap: replace later region first (so earlier indices remain valid)
        replace_region(buf, second.row, second.s, second.e, first.text)
        replace_region(buf, first.row, first.s, first.e, second.text)
    end
end

-- Emacs also has a "backward" notion (swap previous word with current/next).
-- Implementing explicit "transpose before point" (like M-T) --
-- We'll choose: find previous word (the one before point), then find the word after it, and swap.
function M.transpose_words_emacs_backward()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col0 = pos[1], pos[2]
    local col_byte = col0 + 1

    -- Find the previous word relative to cursor (the candidate left-hand side)
    local prev = find_prev_word(buf, row, col_byte)
    if not prev then
        return
    end

    -- Find the next word after prev (the right-hand side)
    local saved_cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { prev.row, prev.e - 1 }) -- set cursor near end of prev for consistent search
    local nextw = find_next_word(buf, prev.row, prev.e + 1)
    vim.api.nvim_win_set_cursor(0, saved_cursor)
    if not nextw then
        return
    end

    if prev.row == nextw.row then
        local line = vim.api.nvim_buf_get_lines(buf, prev.row - 1, prev.row, false)[1] or ''
        local a = line:sub(1, prev.s - 1)
        local between = line:sub(prev.e + 1, nextw.s - 1)
        local after = line:sub(nextw.e + 1, -1)
        local new = a .. nextw.text .. between .. prev.text .. after
        vim.api.nvim_buf_set_lines(buf, prev.row - 1, prev.row, false, { new })
    else
        replace_region(buf, nextw.row, nextw.s, nextw.e, prev.text)
        replace_region(buf, prev.row, prev.s, prev.e, nextw.text)
    end
end

-- Keymaps: normal & insert (insert does exit/perform/re-enter — approximate)
vim.keymap.set('n', '<M-t>', function()
    M.transpose_words_emacs()
end, { noremap = true, silent = true })
vim.keymap.set('n', '<M-T>', function()
    M.transpose_words_emacs_backward()
end, { noremap = true, silent = true })

vim.keymap.set('i', '<M-t>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    M.transpose_words_emacs()
    vim.api.nvim_feedkeys('a', 'n', true)
end, { noremap = true, silent = true })

vim.keymap.set('i', '<M-T>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    M.transpose_words_emacs_backward()
    vim.api.nvim_feedkeys('a', 'n', true)
end, { noremap = true, silent = true })

return M
