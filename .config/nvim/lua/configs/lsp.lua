-- require('neoconf').setup {}
require('fidget').setup {}

vim.diagnostic.config {
    virtual_text = false,
    float = { border = 'rounded', source = 'if_many' },
    severity_sort = true,
    underline = false,
    signs = true,
    update_in_insert = true,
}

-- disable semantic tokens provider
local function on_init(client, _)
    if client.supports_method 'textDocument/semanticTokens' then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

local function on_attach(client, _)
    client.server_capabilities.documentHighlightProvider = false
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = require('blink.cmp').get_lsp_capabilities()

require('mason').setup()

local servers = {
    lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = {
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
        },
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.fn.expand '$VIMRUNTIME/lua',
                        vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
                        '${3rd}/luv/library',
                        '${3rd}/busted/library',
                    },
                },
                completion = { callSnippet = 'Replace' },
                diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },

    pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
            '.git',
        },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'openFilesOnly',
                },
            },
        },
        on_attach = function(client, bufnr)
            vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
                local params = {
                    command = 'pyright.organizeimports',
                    arguments = { vim.uri_from_bufnr(bufnr) },
                }

                -- Using client.request() directly because "pyright.organizeimports" is private
                -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
                -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
                client.request('workspace/executeCommand', params, nil, bufnr)
            end, {
                desc = 'Organize Imports',
            })

            local function set_python_path(command)
                local path = command.args
                local clients = vim.lsp.get_clients {
                    bufnr = vim.api.nvim_get_current_buf(),
                    name = 'pyright',
                }
                for _, client in ipairs(clients) do
                    if client.settings then
                        client.settings.python = vim.tbl_deep_extend('force', lient.settings.python, { pythonPath = path })
                    else
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
                    end
                    client:notify('workspace/didChangeConfiguration', { settings = nil })
                end
            end

            vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
                desc = 'Reconfigure pyright with the provided python path',
                nargs = 1,
                complete = 'file',
            })
        end,
    },

    jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        init_options = {
            provideFormatter = true,
        },
        root_markers = { '.git' },
        validate = { enable = true },
        schemas = {
            {
                -- this will autocomplete valid keys
                fileMatch = { 'electron-builder.json' },
                url = 'https://raw.githubusercontent.com/electron-userland/electron-builder/master/packages/app-builder-lib/scheme.json',
            },
        },
    },

    sqls = {
        cmd = { 'sqls' },
        filetypes = { 'sql', 'mysql' },
        root_markers = { 'config.yml' },
        settings = {},
    },

    cssls = {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        init_options = { provideFormatter = false },
        root_markers = { 'package.json', '.git' },
        settings = {
            css = { validate = true },
            scss = { validate = true },
        },
    },

    html = {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html', 'ejs', 'pug' },
        root_markers = { 'package.json', '.git' },
        init_options = { embeddedLanguages = { css = true, javascript = true } },
    },

    graphql = {
        cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
        filetypes = { 'gql', 'graphql' }, -- maybe add js, ts, jsx, and tsx later on a better hardware
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(vim.lsp.cofig.util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*')(fname))
        end,
        -- settings = {
        --     graphql = {
        --         schema = 'graphql.schema.json',
        --     },
        -- },
    },

    emmet_language_server = {
        filetypes = {
            'css',
            'sass',
            'scss',
            'html',
            'ejs',
            'pug',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'vue',
        },
        init_options = {
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = 'always',
            showSuggestionsAsSnippets = false,
        },
        root_markers = { '.git' },
    },

    -- ts_ls = {
    --   filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    --   root_dir = lspconfig.util.root_pattern('tsconfig.json', '.git'),
    --   init_options = {
    --     preferences = {
    --       disableSuggestions = true,
    --     },
    --   },
    -- },

    -- vtsls = {
    --     cmd = { 'vtsls', '--stdio' },
    --     filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    --     root_dir = function(fname)
    --         -- disable tsserver inside any folder that has deno.json
    --         if util.root_pattern('deno.json', 'deno.jsonc')(fname) then
    --             return nil
    --         end
    --         return util.root_pattern('tsconfig.json', 'package.json', '.git')(fname)
    --     end,
    --     single_file_support = true,
    --     init_options = {
    --         preferences = {
    --             disableSuggestions = true,
    --         },
    --     },
    --     settings = {
    --         vtsls = {
    --             autoUseWorkspaceTsdk = true,
    --             enableMoveToFileCodeAction = true,
    --         },
    --     },
    -- },

    tailwindcss = {
        cmd = { 'tailwindcss-language-server', '--stdio' },
        filetypes = {
            'ejs',
            'html',
            'markdown',
            'php',
            -- css
            'css',
            'sass',
            'scss',
            -- js
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            -- mixed
            'vue',
            'svelte',
        },
        settings = {
            tailwindCSS = {
                validate = true,
                lint = {
                    cssConflict = 'warning',
                    invalidApply = 'error',
                    invalidScreen = 'error',
                    invalidVariant = 'error',
                    invalidConfigPath = 'error',
                    invalidTailwindDirective = 'error',
                    recommendedVariantOrder = 'warning',
                },
                classAttributes = {
                    'class',
                    'className',
                    'class:list',
                    'classList',
                    'ngClass',
                },
                includeLanguages = {
                    eelixir = 'html-eex',
                    elixir = 'phoenix-heex',
                    eruby = 'erb',
                    heex = 'phoenix-heex',
                    htmlangular = 'html',
                    templ = 'html',
                },
            },
        },
        before_init = function(_, config)
            if not config.settings then
                config.settings = {}
            end
            if not config.settings.editor then
                config.settings.editor = {}
            end
            if not config.settings.editor.tabSize then
                config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
            end
        end,
        root_dir = function(bufnr, on_dir)
            local util = require 'lspconfig.util'
            local root_files = {
                -- Generic
                'tailwind.config.js',
                'tailwind.config.cjs',
                'tailwind.config.mjs',
                'tailwind.config.ts',
                'postcss.config.js',
                'postcss.config.cjs',
                'postcss.config.mjs',
                'postcss.config.ts',
                -- Tailwind v4 fallback (no config file)
                'vite.config.ts',
                -- '.git',
            }

            local fname = vim.api.nvim_buf_get_name(bufnr)
            root_files = util.insert_package_json(root_files, 'tailwindcss', fname)
            root_files = util.root_markers_with_field(root_files, { 'mix.lock', 'Gemfile.lock' }, 'tailwind', fname)
            on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
        end,
    },

    -- denols = {
    --     cmd = { 'deno', 'lsp' },
    --     cmd_env = { NO_COLOR = true },
    --     filetypes = {
    --         'javascript',
    --         'javascriptreact',
    --         'javascript.jsx',
    --         'typescript',
    --         'typescriptreact',
    --         'typescript.tsx',
    --     },
    --     root_markers = { 'deno.json', 'deno.jsonc' },
    --     settings = {
    --         deno = {
    --             enable = true,
    --             lint = true,
    --             unstable = true,
    --             suggest = {
    --                 imports = {
    --                     hosts = {
    --                         ['https://deno.land'] = true,
    --                         -- ['https://jsr.io'] = true,
    --                         -- ['https://esm.sh'] = true,
    --                     },
    --                 },
    --             },
    --         },
    --     },
    --     handlers = (function()
    --         local lsp = vim.lsp
    --
    --         -- handle virtual text documents from Deno (for definitions, etc.)
    --         local function virtual_text_document_handler(uri, res, client)
    --             if not res then
    --                 return
    --             end
    --             local lines = vim.split(res.result, '\n')
    --             local bufnr = vim.uri_to_bufnr(uri)
    --             if vim.api.nvim_buf_line_count(bufnr) ~= 1 or vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] ~= '' then
    --                 return
    --             end
    --             vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    --             vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
    --             vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    --             lsp.buf_attach_client(bufnr, client.id)
    --         end
    --
    --         local function virtual_text_document(uri, client)
    --             local params = { textDocument = { uri = uri } }
    --             local result = client:request_sync('deno/virtualTextDocument', params)
    --             virtual_text_document_handler(uri, result, client)
    --         end
    --
    --         local function denols_handler(err, result, ctx, config)
    --             if not result or vim.tbl_isempty(result) then
    --                 return
    --             end
    --             local client = vim.lsp.get_client_by_id(ctx.client_id)
    --             for _, res in pairs(result) do
    --                 local uri = res.uri or res.targetUri
    --                 if uri:match '^deno:' then
    --                     virtual_text_document(uri, client)
    --                     res.uri, res.targetUri = uri, uri
    --                 end
    --             end
    --             lsp.handlers[ctx.method](err, result, ctx, config)
    --         end
    --
    --         return {
    --             ['textDocument/definition'] = denols_handler,
    --             ['textDocument/typeDefinition'] = denols_handler,
    --             ['textDocument/references'] = denols_handler,
    --         }
    --     end)(),
    --
    --     on_attach = function(client, bufnr)
    --         -- disable semantic tokens like the rest of your setup
    --         if client.supports_method 'textDocument/semanticTokens' then
    --             client.server_capabilities.semanticTokensProvider = nil
    --         end
    --
    --         vim.api.nvim_buf_create_user_command(bufnr, 'LspDenolsCache', function()
    --             client:exec_cmd({
    --                 command = 'deno.cache',
    --                 arguments = { {}, vim.uri_from_bufnr(bufnr) },
    --             }, { bufnr = bufnr }, function(err, _, ctx)
    --                 if err then
    --                     local uri = ctx.params.arguments[2]
    --                     vim.notify('cache command failed for ' .. vim.uri_to_fname(uri), vim.log.levels.ERROR)
    --                 end
    --             end)
    --         end, {
    --             desc = 'Cache a Deno module and its dependencies',
    --         })
    --     end,
    -- },
}

require('mason-tool-installer').setup {
    ensure_installed = {
        -- lsp's
        'lua-language-server',
        'clangd',
        'css-lsp',
        'html-lsp',
        'tailwindcss-language-server',
        -- 'typescript-language-server',
        'emmet-language-server',
        'vtsls',

        -- formatters
        'stylua',
        'prettier',
        'prettierd',
        'clang-format',
        'stylelint',
        'jsonlint',

        -- linters
        'eslint',
        'eslint_d',
        'markuplint',
        'stylelint',
        'jsonlint',
    },
    auto_update = true,
    run_on_start = false,
}

for name, config in pairs(servers) do
    local cfg = vim.tbl_deep_extend('force', {
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
        -- handlers = {
        --     ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        --     ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
        -- },
    }, config or {})

    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
end

-- (ts support for vue) from ts_ls docs

-- local util = require 'lspconfig.util'
--
-- return {
--   default_config = {
--     init_options = { hostInfo = 'neovim' },
--     cmd = { 'typescript-language-server', '--stdio' },
--     filetypes = {
--       'javascript',
--       'javascriptreact',
--       'javascript.jsx',
--       'typescript',
--       'typescriptreact',
--       'typescript.tsx',
--     },
--     root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
--     single_file_support = true,
--   },
--   docs = {
--     description = [[
-- https://github.com/typescript-language-server/typescript-language-server
--
-- `ts_ls`, aka `typescript-language-server`, is a Language Server Protocol implementation for TypeScript wrapping `tsserver`. Note that `ts_ls` is not `tsserver`.
--
-- `typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
-- ```sh
-- npm install -g typescript typescript-language-server
-- ```
--
-- To configure typescript language server, add a
-- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
-- [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
-- project.
--
-- Here's an example that disables type checking in JavaScript files.
--
-- ```json
-- {
--   "compilerOptions": {
--     "module": "commonjs",
--     "target": "es6",
--     "checkJs": false
--   },
--   "exclude": [
--     "node_modules"
--   ]
-- }
-- ```
--
-- ### Vue support
--
-- As of 2.0.0, Volar no longer supports TypeScript itself. Instead, a plugin
-- adds Vue support to this language server.
--
-- *IMPORTANT*: It is crucial to ensure that `@vue/typescript-plugin` and `volar `are of identical versions.
--
-- ```lua
-- require'lspconfig'.ts_ls.setup{
--   init_options = {
--     plugins = {
--       {
--         name = "@vue/typescript-plugin",
--         location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
--         languages = {"javascript", "typescript", "vue"},
--       },
--     },
--   },
--   filetypes = {
--     "javascript",
--     "typescript",
--     "vue",
--   },
-- }
--
-- -- You must make sure volar is setup
-- -- e.g. require'lspconfig'.volar.setup{}
-- -- See volar's section for more information
-- ```
--
-- `location` MUST be defined. If the plugin is installed in `node_modules`,
-- `location` can have any value.
--
-- `languages` must include `vue` even if it is listed in `filetypes`.
--
-- `filetypes` is extended here to include Vue SFC.
-- ]],
