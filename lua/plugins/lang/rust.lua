vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>pa", function()
				vim.cmd.RustLsp("codeAction")
			end, { buffer = bufnr, silent = true, desc = "Code action" })
			vim.keymap.set("n", "<leader>pd", function()
				vim.cmd.RustLsp("renderDiagnostic")
			end, { buffer = bufnr, silent = true, desc = "Render diagnostic" })
			vim.keymap.set("n", "<leader>pD", function()
				vim.cmd.RustLsp("openDocs")
			end, { buffer = bufnr, silent = true, desc = "Docs" })
			vim.keymap.set("n", "<leader>pe", function()
				vim.cmd.RustLsp("explainError")
			end, { buffer = bufnr, silent = true, desc = "Explain error" })
			vim.keymap.set("n", "<leader>pr", function()
				vim.cmd.RustLsp("runnables")
			end, { buffer = bufnr, silent = true, desc = "Run" })
		end,
	},
}
