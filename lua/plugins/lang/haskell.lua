local ht = require("haskell-tools")
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "haskell", "cabal", "cabalproject" },
	callback = function(args)
		vim.keymap.set("n", "<space>pl", vim.lsp.codelens.run, { buffer = args.buf, desc = "Codelens run" })
		vim.keymap.set("n", "<space>ps", ht.hoogle.hoogle_signature, { buffer = args.buf, desc = "Hoogle signature" })
		vim.keymap.set("n", "<space>pa", ht.lsp.buf_eval_all, { buffer = args.buf, desc = "Eval all" })
		vim.keymap.set("n", "<leader>pr", ht.repl.toggle, { buffer = args.buf, desc = "Package repl" })
		vim.keymap.set("n", "<leader>pf", function()
			ht.repl.toggle(vim.api.nvim_buf_get_name(0))
		end, { buffer = args.buf, desc = "Buffer repl" })
		vim.keymap.set("n", "<leader>pq", ht.repl.quit, { buffer = args.buf, desc = "Quit repl" })
	end,
})
