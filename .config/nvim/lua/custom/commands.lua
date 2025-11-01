-- *:Gsplit!*      Superseded by |:Git_--paginate|.
-- *:Gvsplit!*     Superseded by :vert Git --paginate.
-- *:Gtabsplit!*   Superseded by :tab Git --paginate.
-- *:Gpedit!*      Superseded by :Git! --paginate.

vim.api.nvim_create_user_command('Gl', function()
    vim.cmd 'Gclog'
end, {})

vim.api.nvim_create_user_command('Gpf', function()
    vim.cmd 'G push --force-with-lease'
end, {})

vim.api.nvim_create_user_command('Gcm', function()
    vim.cmd 'G commit'
end, {})

vim.api.nvim_create_user_command('Gp', function()
    vim.cmd 'G push'
end, {})

vim.api.nvim_create_user_command('Gdiff', function()
    vim.cmd 'vert Gdiffsplit'
end, {})

vim.api.nvim_create_user_command('Ghdiff', function()
    vim.cmd 'Ghdiffsplit'
end, {})

vim.api.nvim_create_user_command('Gvdiff', function()
    vim.cmd 'Gvdiffsplit'
end, {})

vim.api.nvim_create_user_command('Gfetch', function()
    vim.cmd 'G fetch'
end, {})

vim.api.nvim_create_user_command('Gmerge', function()
    vim.cmd 'G merge'
end, {})

vim.api.nvim_create_user_command('Grebase', function()
    vim.cmd 'G rebase'
end, {})

vim.api.nvim_create_user_command('Grevert', function()
    vim.cmd 'G revert'
end, {})

vim.api.nvim_create_user_command('Gpull', function()
    vim.cmd 'G pull'
end, {})
