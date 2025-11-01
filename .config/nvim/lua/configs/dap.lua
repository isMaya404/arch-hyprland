local dap = require 'dap'
local dapui = require 'dapui'

-------------------------------- Dap UI Setup --------------------------------

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- see |:help nvim-dap-ui|
dapui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
        icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
        },
    },
}

-------------------------------- Virtual Text Setup --------------------------------

require('nvim-dap-virtual-text').setup {}

-------------------------------- Breakpiont Icons --------------------------------

vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
    local tp = 'Dap' .. type
    local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

-------------------------------- Dap Adapters --------------------------------

if not dap.adapters['pwa-node'] then
    require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
            command = 'node',
            args = {
                vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                '${port}',
            },
        },
    }
end

if not dap.adapters['node'] then
    dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then
            config.type = 'pwa-node'
        end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
        else
            cb(nativeAdapter)
        end
    end
end

-- laggy
-- dap.adapters.firefox = {
--   type = 'executable',
--   command = 'node',
--   args = {
--     vim.fn.stdpath 'data' .. '/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js',
--   },
-- }

-------------------------------- Dap Adapter Configurations --------------------------------

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

local vscode = require 'dap.ext.vscode'
vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
        dap.configurations[language] = {
            -- Debug client side (laggy)
            -- {
            --   name = 'Debug with Firefox',
            --   type = 'firefox',
            --   request = 'launch',
            --   reAttach = true,
            --   webRoot = '${workspaceFolder}',
            --   firefoxExecutable = '/usr/bin/firefox',
            --   url = function()
            --     local co = coroutine.running()
            --     return coroutine.create(function()
            --       vim.ui.input({
            --         prompt = 'Enter URL: ',
            --         default = 'http://localhost:3000',
            --       }, function(url)
            --         if url == nil or url == '' then
            --           return
            --         else
            --           coroutine.resume(co, url)
            --         end
            --       end)
            --     end)
            --   end,
            --   sourceMaps = true,
            --   userDataDir = false,
            -- },
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
            },
        }
    end
end

-------------------------------- Keybindings --------------------------------
local keys = {
    {
        '<F5>',
        function()
            require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
    },
    {
        '<F1>',
        function()
            require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
    },
    {
        '<F2>',
        function()
            require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
    },
    {
        '<F3>',
        function()
            require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
    },
    {
        '<leader>db',
        function()
            require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
    },
    {
        '<leader>dB',
        function()
            require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
    },
    {
        '<F7>',
        function()
            require('dapui').toggle()
        end,
        desc = 'Debug: Toggle DAP UI',
    },
}

for _, key in ipairs(keys) do
    vim.keymap.set('n', key[1], key[2], { desc = keys.desc })
end
