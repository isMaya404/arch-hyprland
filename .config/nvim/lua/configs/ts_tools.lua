require('typescript-tools').setup {
    root_dir = function(fname)
        return require('lspconfig.util').root_pattern('tsconfig.json', 'package.json', '.git')(fname)
    end,
    -- on_attach = function(client, bufnr)
    -- local fs = vim.fs
    --
    -- -- find project root via nearest .git
    -- local startpath = vim.api.nvim_buf_get_name(bufnr)
    -- local git_dir = fs.find('.git', { path = startpath, upward = true })[1]
    -- local root = git_dir and fs.dirname(git_dir) or fs.dirname(startpath)
    --
    -- -- detect Deno project
    -- local deno_json = fs.find({ 'deno.json', 'deno.jsonc' }, { path = root, upward = true })[1]
    -- if deno_json then
    --     vim.schedule(function()
    --         client.stop()
    --         vim.notify('Stopped tsserver (typescript-tools) in Deno project', vim.log.levels.INFO)
    --     end)
    --     return
    -- end
    -- end,
    handlers = {},
    settings = {
        -- single_file_support = false,
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_max_memory = 'auto',
        tsserver_locale = 'en',
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = 'off',
        disable_member_code_lens = true,
        jsx_close_tag = {
            enable = false,
            filetypes = { 'javascriptreact', 'typescriptreact' },
        },
        tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
            disableSuggestions = false,
        },
        tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
            includeCompletionsWithInsertText = true,
            providePrefixAndSuffixTextForRename = true,
        },
        tsserver_plugins = {
            -- for TypeScript v4.9+

            -- or for older TypeScript versions
            -- 'typescript-styled-plugin',
        },
    },
}
