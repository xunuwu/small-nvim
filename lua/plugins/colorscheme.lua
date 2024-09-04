return function(colorscheme)
	MiniDeps.add(colorscheme.package)
	if colorscheme.extraConfig then
		dofile(colorscheme.extraConfig)
	end
	vim.cmd.colorscheme(colorscheme.name)
end
