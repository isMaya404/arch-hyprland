vim.g.VM_mouse_mappings = 1
vim.g.VM_add_cursor_at_pos_no_mappings = 1
vim.g.VM_default_mappings = 0
-- vim.g.VM_LEADER = 'foo' -- not setting this since default mapping's off

-- Set visual multi leader key
local VM_LEADER = '<leader>v' -- equivalent to space + v

vim.g.VM_maps = {

    -- Basic usage (and prob 90% of what I need)
    ['Find Under'] = '<C-n>',
    ['Find Subword Under'] = '<C-n>',

    ['Add Cursor Down'] = '<C-M-k>',
    ['Add Cursor Up'] = '<C-M-l>',

    ['Select All'] = VM_LEADER .. 'sa',

    -- Mouse Bindings
    ['Mouse Word'] = '<C-LeftMouse>', -- select word and adds cursor at the end of word
    ['Mouse Cursor'] = '<C-RightMouse>', -- select single char and adds cursor
    ['Mouse Column'] = '<C-M-LeftMouse>',

    ['Skip Region'] = 'q',
    ['Remove Region'] = 'Q',

    ['Find Next'] = 'n',
    ['Find Previous'] = 'N',

    ['Undo'] = 'u',
    ['Redo'] = '<C-r>',

    ['Toggle Mappings'] = VM_LEADER .. '<leader>', -- maps to -> space + v + space
    -- activates Visual Multi’s multi-cursor editing mode "AFTER" you've manually placed cursors.

    ['Visual Cursors'] = VM_LEADER .. 'c',
    -- Use this after highlighting multiple lines using v-mode and want to promote it to multicursor.

    ['Add Cursor At Pos'] = VM_LEADER .. 'p',
    -- Add a new cursor at the current position. Works in normal mode. You can drop multiple cursors anywhere.
    -- After dropping cursor, toggle mappings by vm_leader + t (or whatever binding is set) to start editing

    ---------------------------------------------------------------------------

    -- Advanced Usage (many of which I don't use, not very useful, and is not included here)

    -- See Documentation
    -- :help visual-multi
    -- :help vm-some-topic

    -- Run tutorial
    -- vim -Nu path/to/visual-multi/tutorialrc

    ['Switch Mode'] = '<Tab>', -- cursor and extend mode

    ['Start Regex Search'] = VM_LEADER .. '/',
    ['Visual Regex'] = VM_LEADER .. '/', -- scoped using v-mode
    ['Case Conversion Menu'] = VM_LEADER .. 'C',

    ['Goto Next'] = ']',
    ['Goto Previous'] = '[',

    -- \\a   aligns by setting the minimum column to the highest of all regions
    -- \\<   aligns by character, or [count] characters
    -- \\>   aligns by regex pattern
    ['Align'] = VM_LEADER .. 'a',
    ['Align Char'] = VM_LEADER .. '<',
    ['Align Regex'] = VM_LEADER .. '>',
}
