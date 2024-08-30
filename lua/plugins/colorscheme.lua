return function(colorscheme)
	MiniDeps.add(colorscheme.package)
	dofile(colorscheme.extraConfig)
	vim.cmd.colorscheme(colorscheme.name)
end
