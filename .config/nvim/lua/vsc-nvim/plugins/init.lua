return {
    {
        'ThePrimeagen/harpoon',
        event = 'VeryLazy',
        branch = 'harpoon2',
        config = function()
            require 'configs.harpoon'
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '^3.0.0',
        event = 'VeryLazy',
        config = function()
            -- require 'configs.nvim_surround'
            require('nvim-surround').setup {
                keymaps = {
                    normal = 'os',
                    normal_cur = 'oss',
                    normal_line = 'oS',
                    normal_cur_line = 'oSS',
                },
            }
        end,
        --     Basics:
        --     surr*ound_words             ysiw)           (surround_words)
        --     *make strings               ys$"            "make strings"
        --     [delete ar*ound me!]        ds]             delete around me!
        --     remove <b>HTML t*ags</b>    dst             remove HTML tags
        --     <p>or tag* types</p>        csth1<CR>       <h1>or tag types</h1>
        --     'change quot*es'            cs'"            "change quotes"
    },
}
