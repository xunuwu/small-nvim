local lspconfig = require("lspconfig");
(function(conf)
	for _, v in ipairs(conf) do
		if type(v) == "string" then
			lspconfig[v].setup({})
		elseif type(v) == "table" then
			local opts = v[2] or {}
			lspconfig[v[1]].setup(opts)
		end
	end
end)({
	"clangd",
	"lua_ls",
	"tsserver",
	"zls",
	"nil_ls",
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
	},
})

local autoFormatFiletypes = {
	"nix",
	"lua",
	"zig",
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = args.buf })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = args.buf })
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = args.buf })
		vim.keymap.set({ "n", "v" }, "<leader>lf", conform.format, { buffer = args.buf })
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = args.buf })
		vim.keymap.set("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, { buffer = args.buf })
	end,
})

local formatPattern = ""
for i, v in ipairs(autoFormatFiletypes) do
	if i ~= 1 then
		formatPattern = formatPattern .. ","
	end
	formatPattern = formatPattern .. "*." .. v
end

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = formatPattern,
	callback = function(args)
		conform.format({ bufnr = args.buf })
	end,
})
