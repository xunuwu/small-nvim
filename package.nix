{
  wrapNeovimUnstable,
  neovimUtils,
  neovim,
  lib,
  gcc,
  ripgrep,
  git,
  tree-sitter,
  conf ? "",
}:
wrapNeovimUnstable neovim (neovimUtils.makeNeovimConfig
  {
    customRC = ''
      set runtimepath^=${./.}
      source ${conf}
      source ${./init.lua}
    '';
    wrapperArgs = [
      ''
        --suffix PATH : "${lib.makeBinPath [
          gcc
          ripgrep
          git

          tree-sitter
        ]}
      ''
    ];
    withNodeJs = true;
  })
