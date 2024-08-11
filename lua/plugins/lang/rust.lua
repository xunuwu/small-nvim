vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>pa", function()
				vim.cmd.RustLsp("codeAction")
			end, { buffer = bufnr, silent = true })
			vim.keymap.set("n", "<leader>pd", function()
				vim.cmd.RustLsp("openDocs")
			end, { buffer = bufnr, silent = true })
		end,
	},
}
