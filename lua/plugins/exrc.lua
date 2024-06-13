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
		local fn, error = load(contents)
		if error then
			print(error)
		elseif fn then
			fn()
		end
	end
end
