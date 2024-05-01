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
       "nil_ls"
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
