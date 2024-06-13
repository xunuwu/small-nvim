pcall(function()
	vim.loader.enable()
end)

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	add("EdenEast/nightfox.nvim")
	require("plugins.colorscheme")
end)

now(function()
	require("opts")
end)

now(function()
	require("keys")
end)

now(function()
	require("mini.statusline").setup()
end)

now(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.extra").setup()
end)

later(function()
	require("mini.pairs").setup()
end)

later(function()
	require("mini.pick").setup()
	vim.keymap.set("n", "<leader>f", MiniPick.builtin.files, { desc = "File search" })
	vim.keymap.set("n", "<leader>ss", MiniPick.builtin.grep_live, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep, { desc = "Grep" })
	vim.keymap.set("n", "<leader>sb", MiniPick.builtin.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "Help" })
	vim.keymap.set("n", "<leader>sd", MiniExtra.pickers.diagnostic, { desc = "Diagnostic" })
	vim.keymap.set("n", "<leader>sr", MiniExtra.pickers.registers, { desc = "Registers" })

	vim.keymap.set("n", "<leader>slr", function()
		MiniExtra.pickers.lsp({ scope = "references" })
	end, { desc = "References" })
end)

later(function()
	add("wakatime/vim-wakatime")
end)

now(function()
	require("mini.surround").setup()
end)

now(function()
	require("mini.notify").setup({
		window = {
			config = function()
				local has_statusline = vim.o.laststatus > 0
				local bottom_space = vim.o.cmdheight + (has_statusline and 1 or 0)
				return {
					border = "single",
					anchor = "SE",
					col = vim.o.columns,
					row = vim.o.lines - bottom_space,
				}
			end,
		},
	})
	vim.notify = require("mini.notify").make_notify({
		ERROR = { duration = 5000 },
	})
	vim.api.nvim_create_user_command("Notifyhistory", function()
		require("mini.notify").show_history()
	end, { desc = "Show mini.notify history" })
end)

later(function()
	require("mini.files").setup({
		windows = {
			preview = true,
		},
	})
	vim.keymap.set("n", "<leader>r", function()
		if not MiniFiles.close() then
			MiniFiles.open()
		end
	end, { desc = "File explorer from cwd" })
	vim.keymap.set("n", "<leader>e", function()
		if not MiniFiles.close() then
			MiniFiles.open(vim.fn.expand("%:h"))
		end
	end, { desc = "File explorer from buffer" })

	local show_dotfiles = true

	local filter_show = function(fs_entry)
		return true
	end

	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end

	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		MiniFiles.refresh({ content = { filter = new_filter } })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak left-hand side of mapping to your liking
			vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })
		end,
	})
end)

require("mini.indentscope").setup()

require("mini.misc").setup()
vim.keymap.set("n", "<leader>z", MiniMisc.zoom, { desc = "Zoom" })

now(function()
	add("neovim/nvim-lspconfig")
	add("stevearc/conform.nvim")
	require("plugins.lsp")
end)

require("mini.completion").setup()

later(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			-- leader triggers
			{ mode = "n", keys = "<leader>" },
			{ mode = "x", keys = "<leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},
		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},
		window = {
			delay = 250,
		},
	})
end)

later(function()
	add({
		source = "mfussenegger/nvim-dap",
	})
	require("plugins.dap")
end)

now(function()
	require("plugins.exrc")
end)

-- dependencies ===================
now(function()
	add("nvim-tree/nvim-web-devicons")
end)

later(function()
	local ts_spec = {
		source = "nvim-treesitter/nvim-treesitter",
	}
	add({
		source = "nvim-treesitter/nvim-treesitter",
		-- Use 'master' while monitoring updates in 'main'
		checkout = "master",
		monitor = "main",
		-- Perform action after every checkout
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})

	local ensure_installed = {
		"c",
		"cpp",
		"css",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"rust",
		"toml",
		"tsx",
		"yaml",
		"vim",
		"vimdoc",
	}
	require("nvim-treesitter.configs").setup({
		ensure_installed = ensure_installed,
		highlight = { enable = true },
		incremental_selection = { enable = false },
		textobjects = { enable = false },
		indent = { enable = false },
	})
end)

later(function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "vimdoc" },
		highlight = { enable = true },
	})
end)
