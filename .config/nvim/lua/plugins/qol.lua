return {
    -- NOTE: will try this again in the future, rn I don't like it
    -- {
    --   'saghen/blink.cmp',
    --   version = '1.*',
    --   build = vim.g.lazyvim_blink_main and 'cargo build --release',
    --   dependencies = {
    --     event = 'InsertEnter',
    --     -- Snippet Engine
    --     {
    --       'L3MON4D3/LuaSnip',
    --       version = '2.*',
    --       build = (function()
    --         -- Build Step is needed for regex support in snippets.
    --         -- This step is not supported in many windows environments.
    --         -- Remove the below condition to re-enable on windows.
    --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
    --           return
    --         end
    --         return 'make install_jsregexp'
    --       end)(),
    --       dependencies = {
    --         {
    --           'rafamadriz/friendly-snippets',
    --           config = function()
    --             require('luasnip.loaders.from_vscode').lazy_load()
    --           end,
    --         },
    --       },
    --     },
    --     'folke/lazydev.nvim',
    --   },
    --   config = function()
    --     require 'configs.blink'
    --   end,
    -- },

    {
        'neovim/nvim-lspconfig',
        -- event = 'User FilePost',
        event = 'VeryLazy',
        dependencies = {
            'williamboman/mason.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'j-hui/fidget.nvim',
        },
        config = function()
            require 'configs.lsp'
        end,
    },

    -- makes file ops such as renaming, moving, creating, and deleting
    -- files/dirs in file-trees of your choice lsp-aware .It notifies
    -- the lsp so imports and references update automatically.
    {
        'antosha417/nvim-lsp-file-operations',
        event = 'VeryLazy',
        config = function()
            require('lsp-file-operations').setup()
        end,
    },

    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind.nvim',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'brenoprata10/nvim-highlight-colors',
            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = {
                    library = {
                        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                    },
                },
            },
        },
        opts = require('configs.cmp').opts,
        config = require('configs.cmp').config,
    },

    -- smarter folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        -- event = 'BufReadPost',
        opts = function()
            return require 'configs.nvim_ufo'
        end,
    },

    -- multi cursor
    {
        'mg979/vim-visual-multi',
        branch = 'master',
        event = 'VeryLazy',
        -- init instead of config for remaps to work
        -- See https://github.com/mg979/vim-visual-multi/issues/241
        init = function()
            require 'configs.visual_multi'
        end,
    },

    -- view images in neovim
    {
        '3rd/image.nvim',
        event = 'VeryLazy',
        commit = '4206c48',
        config = function()
            require 'configs.image_nvim.image'
            -- require 'configs.image_nvim.luarocks' -- deps
        end,
    },
}
