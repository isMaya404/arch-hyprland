return {
    { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },

    -- colorscheme
    {
        'gbprod/nord.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nord').setup {
                transparent = false,
            }
            vim.cmd.colorscheme 'nord'
        end,
    },
    install = {
        colorscheme = { 'nord' },
    },

    -- {
    --     'projekt0n/github-nvim-theme',
    --     name = 'github-theme',
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require('github-theme').setup {
    --             -- ...
    --         }
    --
    --         vim.cmd 'colorscheme github_dark_dimmed'
    --     end,
    -- },

    -- {
    --     'rose-pine/neovim',
    --     name = 'rose-pine',
    --     config = function()
    --         vim.cmd 'colorscheme rose-pine'
    --     end,
    -- },

    -- {
    --     'andreypopp/vim-colors-plain',
    --     lazy = false,
    --     priority = 1000,
    --     init = function()
    --         vim.cmd [[colorscheme plain]]
    --         vim.o.background = 'dark'
    --     end,
    -- },

    -- session manaager
    -- {
    --     'rmagatti/auto-session',
    --     event = 'VimEnter',
    --     config = function()
    --         require 'configs.auto_session'
    --     end,
    -- },

    -- session manager (saves even tabs)
    {
        'stevearc/resession.nvim',
        lazy = false,
        dependencies = {
            {
                'tiagovla/scope.nvim',
                lazy = false,
                config = true,
            },
        },
        opts = {
            buf_filter = function(bufnr)
                local buftype = vim.bo[bufnr].buftype
                if buftype == 'help' then
                    return true
                end
                if buftype ~= '' and buftype ~= 'acwrite' then
                    return false
                end
                if vim.api.nvim_buf_get_name(bufnr) == '' then
                    return false
                end

                return true
            end,
            extensions = { scope = {} },
            dir = 'sessions', -- The name of the directory to store sessions in
            load_detail = false,
        },
        config = function(_, opts)
            require('resession').setup(opts)
            require 'configs.resession'
        end,
    },

    -- editorconfig support
    -- {
    --     'editorconfig/editorconfig-vim',
    -- event = 'VeryLazy',
    -- },

    -- automatic, context-aware indentation detection.
    -- also respects .editorconfig
    {
        'tpope/vim-sleuth',
        event = 'VeryLazy',
    },

    -- auto inserts and deletes matching pairs of paren, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        opts = {
            fast_wrap = {},
            disable_filetype = { 'TelescopePrompt', 'vim' },
        },
        config = function(_, opts)
            require('nvim-autopairs').setup(opts)
            -- require('nvim-autopairs').enable_cmdline()
        end,
    },

    -- git integration

    {
        'tpope/vim-fugitive',
        event = 'VeryLazy',
    },

    -- {
    --     'NeogitOrg/neogit',
    --     -- event = 'VeryLazy',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'sindrets/diffview.nvim',
    --         'nvim-telescope/telescope.nvim',
    --     },
    --     config = function()
    --         require 'configs.neogit'
    --     end,
    -- },

    {
        'lewis6991/gitsigns.nvim',
        event = 'BufReadPost',
        config = function()
            require 'configs.gitsigns'
        end,
    },

    -- file tree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
        config = function()
            require 'configs.nvim_tree'
        end,
    },

    -- file tree as buffer
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        event = 'VeryLazy',
        lazy = true,
    },

    -- blazingly fast???
    {
        'ThePrimeagen/harpoon',
        event = 'VeryLazy',
        branch = 'harpoon2',
        config = function()
            require 'configs.harpoon'
        end,
    },

    -- no more annoyinng default notif
    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        opts = {
            background_colour = '#000000',
            timeout = 3000, -- ms
            max_width = 65,
            stages = 'static',
            render = 'default',
            top_down = false,
        },
        config = function(_, opts)
            require('notify').setup(opts)

            -- override vim.notify
            vim.notify = require 'notify'
        end,
    },

    -- file picker
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },
        config = function()
            require 'configs.telescope'
        end,
    },

    -- keymap management
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require 'configs.which_key'
        end,
    },

    -- better comments
    {
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
        opts = {
            signs = false,
            keywords = {
                FIX = {
                    icon = ' ',
                    color = 'error',
                    alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = ' ', color = 'info' },
                HACK = { icon = ' ', color = 'warning' },
                WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
                TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
            },
        },
    },

    -- syntax highlighting, motions, folding, text objects, etc.
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- sets main module to use for opts
        config = function()
            require 'configs.tree_sitter'
        end,
        -- opts = {
        -- },
    },

    -- linter
    {
        'nvimtools/none-ls.nvim',
        dependencies = {
            'nvimtools/none-ls-extras.nvim',
        },
        event = 'VeryLazy',
        opts = function()
            return require 'configs.none_ls'
        end,
    },

    -- formatter
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        config = function()
            require 'configs.conform'
        end,
    },

    -- cursor ai emulation
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        version = false, -- should always be false according to docs
        build = 'make',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'MunifTanjim/nui.nvim',
            'zbirenbaum/copilot.lua', -- for providers='copilot'
            {
                -- support for image pasting
                'HakonHarnes/img-clip.nvim',
                event = 'VeryLazy',
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        use_absolute_path = true,
                    },
                },
            },
        },
        config = function()
            return require 'configs.avante'
        end,
    },

    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require 'configs.copilot'
        end,
    },

    -- peak free code completion ai
    -- {
    --   "Exafunction/windsurf.nvim",
    --   -- lazy = true,
    --   event = "InsertEnter",
    --   dependencies = {
    --     "hrsh7th/nvim-cmp",
    --   },
    --   config = function()
    --     require "configs.windsurf"
    --   end,
    -- },

    -- snippet engine
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' }, -- snippet collections from vscode
        verion = 'v2.*',
        build = 'make install_jsregexp',
        event = 'VeryLazy',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_lua').load {
                paths = { vim.fn.stdpath 'config' .. '/lua/snippets' },
            }
        end,
    },

    -- snippets lookup with telescope
    {
        'benfowler/telescope-luasnip.nvim',
        module = 'telescope._extensions.luasnip',
        event = 'VeryLazy',
    },

    -- surround, delete around, etc.
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
                    normal_line = 'OS',
                    normal_cur_line = 'OSS',
                },
            }
        end,
        --     surr*ound_words             osiw)           (surround_words)
        --     *make strings               os$"            "make strings"
        --     [delete ar*ound me!]        ds[             delete around me!
        --     remove <h1>HTML t*ags</h1>    dst             remove HTML tags
        --     <h1>or tag* types</h1>        csth1<CR>       <h1>or tag types</h1>
        --     'change quot*es'            cs'"            "change quotes"
    },

    -- idk, might never use this again
    -- {
    --     'akinsho/bufferline.nvim',
    --     event = 'VeryLazy',
    --     version = '*',
    --     config = function()
    --         require 'configs.bufferline'
    --     end,
    -- },

    -- tui for sql queries. Idk, maybe I'll try this someday
    -- {
    --   'kristijanhusak/vim-dadbod-ui',
    --   event = 'VeryLazy',
    --   dependencies = {
    --     { 'tpope/vim-dadbod', lazy = true },
    --     { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    --     cmd = {
    --       'DBUI',
    --       'DBUIToggle',
    --       'DBUIAddConnection',
    --       'DBUIFindBuffer',
    --     },
    --     init = function()
    --       -- Your DBUI configuration
    --       vim.g.db_ui_use_nerd_fonts = 1
    --     end,
    --     config = function()
    --       return require 'custom.vim-dadbod-ui'
    --     end,
    --   },
    -- },

    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = 'cd app && npm install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },

    -- better loclist && qflist
    {
        'folke/trouble.nvim',
        opts = {}, -- default
        cmd = 'Trouble',
    },

    -- undotree ui
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        keys = { { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' } },
    },

    -- more efficient typescript lsp
    {
        'pmizio/typescript-tools.nvim',
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        config = function()
            require 'configs.ts_tools'
        end,
    },

    -- {
    --     'folke/neoconf.nvim',
    --     cmd = 'Neoconf',
    -- },

    -- enhances the native commentstring on react
    {
        'folke/ts-comments.nvim',
        enabled = true,
        filetypes = { 'typescriptreact', 'javascriptreact' },
        opts = {
            lang = {
                javascript = {
                    '// %s', -- default commentstring when no treesitter node matches
                    '/* %s */',
                    call_expression = '// %s', -- specific commentstring for call_expression
                    jsx_attribute = '// %s',
                    jsx_element = '{/* %s */}',
                    jsx_fragment = '{/* %s */}',
                    spread_element = '// %s',
                    statement_block = '// %s',
                },
                tsx = {
                    '// %s', -- default commentstring when no treesitter node matches
                    '/* %s */',
                    call_expression = '// %s', -- specific commentstring for call_expression
                    jsx_attribute = '// %s',
                    jsx_element = '{/* %s */}',
                    jsx_fragment = '{/* %s */}',
                    spread_element = '// %s',
                    statement_block = '// %s',
                },
            },
        },
    },

    -- indentation guides
    -- {
    --   'lukas-reineke/indent-blankline.nvim',
    --   main = 'ibl',
    --   event = { 'BufReadPost', 'BufNewFile' },
    --   opts = {
    --     -- indent = {
    --     --   char = '│',
    --     --   tab_char = '│',
    --     -- },
    --     scope = {
    --       enabled = false, -- don't use ibl scope since mini.indentscope handles it
    --     },
    --     exclude = {
    --       filetypes = {
    --         'help',
    --         'alpha',
    --         'dashboard',
    --         'neo-tree',
    --         'Trouble',
    --         'lazy',
    --         'mason',
    --         'notify',
    --         'toggleterm',
    --         'snacks_dashboard',
    --         'snacks_notif',
    --         'snacks_terminal',
    --         'snacks_win',
    --       },
    --     },
    --   },
    -- },
    --

    -- active scope indentation guide
    {
        'echasnovski/mini.indentscope',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        -- opts = {
        --   symbol = '│',
        --   options = { try_as_border = true },
        -- },
        --
        opts = function()
            local indentscope = require 'mini.indentscope'
            return {
                symbol = '│',
                options = { try_as_border = true },
                draw = {
                    delay = 0,
                    animation = indentscope.gen_animation.none(),
                },
            }
        end,
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = {
                    'help',
                    'alpha',
                    'dashboard',
                    'neo-tree',
                    'Trouble',
                    'lazy',
                    'mason',
                    'notify',
                    'toggleterm',
                    'snacks_dashboard',
                    'snacks_notif',
                    'snacks_terminal',
                    'snacks_win',
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- provide bg color around color vals
    {
        'brenoprata10/nvim-highlight-colors',
        event = 'VeryLazy',
        config = function()
            require 'configs.highlight_colors'
        end,
    },

    -- better bufdelete
    {
        'echasnovski/mini.bufremove',
        event = 'VeryLazy',
        version = '*',
    },

    -- isolated buffers per tab
    {
        'tiagovla/scope.nvim',
        event = 'VeryLazy',
        config = function()
            require('scope').setup {}
        end,
    },

    -- testing
    -- {
    --     'nvim-neotest/neotest',
    --     event = 'VeryLazy',
    --     dependencies = {
    --         'nvim-neotest/nvim-nio',
    --         'antoinemadec/FixCursorHold.nvim',
    --         'marilari88/neotest-vitest',
    --         'nvim-neotest/neotest-jest',
    --     },
    --     config = function()
    --         require('neotest').setup {
    --             adapters = {
    --                 require 'neotest-vitest',
    --                 require 'neotest-jest',
    --             },
    --         }
    --     end,
    -- },
}
