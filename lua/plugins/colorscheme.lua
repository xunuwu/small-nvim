return function(colorscheme)
	MiniDeps.add(colorscheme.package)
	vim.cmd.colorscheme(colorscheme.name)
end
