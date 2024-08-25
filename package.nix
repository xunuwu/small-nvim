{
  wrapNeovimUnstable,
  neovimUtils,
  neovim,
  lib,
  gcc,
  ripgrep,
  git,
  tree-sitter,
}:
wrapNeovimUnstable neovim (neovimUtils.makeNeovimConfig
  {
    customRC = ''
      set runtimepath^=${./.}
      source ${./init.lua}
    '';
    wrapperArgs = ''
      --suffix PATH : "${lib.makeBinPath [
        gcc
        ripgrep
        git

        tree-sitter
      ]}"'';
    withNodeJs = true;
  })
