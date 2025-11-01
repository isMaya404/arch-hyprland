require('nvim-treesitter.configs').setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  ensure_installed = {
    'bash',
    'c',
    'tsx',
    'diff',
    'html',
    'css',
    'javascript',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  -- fold = {
  --   enable = true,
  -- },
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.

    additional_vim_regex_highlighting = false,
    -- additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
}
