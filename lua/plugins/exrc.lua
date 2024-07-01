-- executed at VimEnter to ensure that lspconfig
-- will be available in exrc scripts
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local file_names = {
			".nvim.lua",
		}

		local found = {}
		for file in vim.fs.dir(".") do
			for _, v in pairs(file_names) do
				if v == file then
					table.insert(found, file)
				end
			end
		end

		for _, file in pairs(found) do
			local contents = vim.secure.read(file)
			if contents then
				local exec_file, error = load(contents)
				if error then
					print(error)
				elseif exec_file then
					exec_file()
				end
			end
		end
	end,
})
