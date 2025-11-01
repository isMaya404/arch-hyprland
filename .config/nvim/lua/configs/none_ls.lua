local null_ls = require 'null-ls'

local eslint_config_files = {
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.js',
    '.eslintrc.mjs',
    '.eslintrc.cjs',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
}

local opts = {
    sources = {
        -- require('none-ls.diagnostics.eslint_d').with {
        --   condition = function(utils)
        --     return utils.root_has_file { eslint_config_files }
        --   end,
        -- },
        require('none-ls.code_actions.eslint_d').with {
            condition = function(utils)
                return utils.root_has_file { eslint_config_files }
            end,
        },

        -- null_ls.builtins.code_actions.gitsigns,
        -- null_ls.builtins.code_actions.gitrebase,
        -- null_ls.builtins.code_actions.ts_node_action,
        -- null_ls.builtins.diagnostics.jsonlint,
    },
}

null_ls.setup(opts)
