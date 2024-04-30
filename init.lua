require('opts')
require('keys')

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
   vim.cmd('echo "Installing `mini.nvim`" | redraw')
   local clone_cmd = {
      'git', 'clone', '--filter=blob:none',
      'https://github.com/echasnovski/mini.nvim', mini_path
   }
   vim.fn.system(clone_cmd)
   vim.cmd('packadd mini.nvim | helptags ALL')
   vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({
   source = 'nvim-treesitter/nvim-treesitter',
   -- Use 'master' while monitoring updates in 'main'
   checkout = 'master',
   monitor = 'main',
   -- Perform action after every checkout
   hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

require('nvim-treesitter.configs').setup({
   ensure_installed = { 'lua', 'vimdoc' },
   highlight = { enable = true },
})



add('nvim-tree/nvim-web-devicons')
require('nvim-web-devicons').setup()

require('mini.statusline').setup()

require("mini.pairs").setup()

require("mini.pick").setup()
require("mini.extra").setup()
vim.keymap.set("n", "<leader>f", MiniPick.builtin.files)
vim.keymap.set("n", "<leader>ss", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep)
vim.keymap.set("n", "<leader>sb", MiniPick.builtin.buffers)
vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help)
vim.keymap.set("n", "<leader>st", MiniExtra.pickers.diagnostic)
vim.keymap.set("n", "<leader>sr", MiniExtra.pickers.registers)

require("mini.files").setup()
vim.keymap.set("n", "<leader>e", MiniFiles.open)

require('mini.indentscope').setup()

require('mini.misc').setup()
vim.keymap.set("n", "<leader>z", MiniMisc.zoom)

-- TODO: Install lspconfig, setup ccls
add({
   source = 'neovim/nvim-lspconfig',
})


local lspconfig = require('lspconfig')

; (function(conf)
   for _, v in ipairs(conf) do
      if type(v) == "string" then
         lspconfig[v].setup({})
      elseif type(v) == "table" then
         lspconfig[v[1]].setup(v[2])
      end
   end
end)({
       "ccls",
       "lua_ls",
       "tsserver",
       "zls",
    })

vim.api.nvim_create_autocmd('LspAttach', {
   callback = function(args)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf })
      vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, { buffer = args.buf })
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = args.buf })
      vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = args.buf })
      vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { buffer = args.buf })
   end,
})

require('mini.completion').setup()

require('mini.jump2d').setup()

require('mini.clue').setup({
   triggers = {
      -- leader triggers
      { mode = "n", keys = '<leader>' },
      { mode = "x", keys = '<leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
   },
})

add({
   source = "mfussenegger/nvim-dap",
})

local dap = require('dap')
dap.adapters.gdb = {
   type = "executable",
   command = "gdb",
   args = { "-i", "dap" },
}

dap.configurations.c = {
   {
      name = "Launch",
      type = "gdb",
      request = "launch",
      program = function()
         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
   },
}

-- TODO: setup nvim-dap keybindings
