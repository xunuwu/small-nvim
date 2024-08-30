local lspconfig = require("lspconfig");
(function(conf)
	for _, v in ipairs(conf) do
		local options = {}
		if type(v) == "string" then
			lspconfig[v].setup(options)
		elseif type(v) == "table" then
			local opts = v[2] and vim.tbl_deep_extend(v[2], options) or options
			lspconfig[v[1]].setup(opts)
		end
	end
end)({
	"clangd",
	"lua_ls",
	"tsserver",
	"zls",
	"nil_ls",
	"nixd",
	"gopls",
	"svelte",
})

local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		zig = { "zigfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
	},
})

local autoFormatFiletypes = {
	"nix",
	"lua",
	"zig",
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, desc = "References" })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = args.buf, desc = "Definition" })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Implementation" })
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = args.buf, desc = "Rename" })
		vim.keymap.set({ "n", "v" }, "<leader>lf", conform.format, { buffer = args.buf, desc = "Format" })
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" })
		vim.keymap.set("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, { buffer = args.buf, desc = "Inlay hints" })
	end,
})

local formatPattern = ""
for i, v in ipairs(autoFormatFiletypes) do
	formatPattern = formatPattern .. (i ~= 1 and "," or "") .. "*." .. v
end

vim.api.nvim_create_autocmd("BufWritePre", {
	-- TODO: just pass an array here as done in plugins/lang/haskell.lua
	pattern = formatPattern,
	callback = function(args)
		conform.format({ bufnr = args.buf })
	end,
})
