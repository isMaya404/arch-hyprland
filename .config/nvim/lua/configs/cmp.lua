local M = {}

function M.opts()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    local border = function(hl)
        return {
            { '╭', hl },
            { '─', hl },
            { '╮', hl },
            { '│', hl },
            { '╯', hl },
            { '─', hl },
            { '╰', hl },
            { '│', hl },
        }
    end

    -- define table
    local mappings = {
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            { 'i', 'c' }
        ),

        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                return
            end
            fallback()
        end, { 'i', 's' }),

        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                return
            end
            fallback()
        end, { 'i', 's' }),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }

    return {
        completion = { completeopt = 'menu,menuone,noinsert' },
        formatting = {
            fields = { 'abbr', 'kind' },
            format = function(entry, item)
                local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
                item = require('lspkind').cmp_format {
                    mode = 'symbol_text',
                    maxwidth = 30,
                    ellipsis_char = '...',
                }(entry, item)
                if color_item.abbr_hl_group then
                    item.kind_hl_group = color_item.abbr_hl_group
                    item.kind = color_item.abbr
                end
                return item
            end,
        },

        window = {
            completion = {
                side_padding = 1,
                scrollbar = false,
                border = border 'CmpBorder',
            },

            documentation = {
                border = border 'CmpDocBorder',
                winhighlight = 'Normal:CmpDoc',
                col_offset = 3,
            },
        },

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        mapping = mappings,

        sources = {
            { name = 'lazydev', group_index = 0 },
            { name = 'nvim_lsp', priority = 1000, max_item_count = 20, group_index = 0 }, -- same index as lazydev to not break cmp
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
            -- { name = 'nvim_lua' }, -- replaced by lazydev
        },

        ['cmp.setup.cmdline:'] = {
            {
                mode = ':',
                opts = {
                    mapping = {
                        ['<C-e>'] = {
                            c = function(fallback)
                                if cmp.visible() then
                                    cmp.close()
                                else
                                    fallback()
                                end
                            end,
                        },

                        ['<Down>'] = cmp.mapping(function()
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                cmp.complete()
                            end
                        end, { 'c' }),

                        ['<Up>'] = cmp.mapping(function()
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                cmp.complete()
                            end
                        end, { 'c' }),

                        ['<Tab>'] = cmp.mapping(function()
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                cmp.complete()
                            end
                        end, { 'c' }),
                        ['<S-Tab>'] = cmp.mapping(function()
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                cmp.complete()
                            end
                        end, { 'c' }),
                    },

                    sources = cmp.config.sources({
                        { name = 'path', keyword_length = 3 },
                    }, {
                        { name = 'cmdline', keyword_length = 3 },
                    }),

                    completion = {
                        autocomplete = false,
                        completeopt = 'menu',
                    },
                },
            },
        },
    }
end

function M.config(_, opts)
    require('luasnip.loaders.from_vscode').lazy_load()
    require('cmp').setup(opts)
    require('cmp').setup.cmdline(':', opts['cmp.setup.cmdline:'][1].opts)
end

return M
