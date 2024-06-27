{
  description = "xun's neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  } @ inputs:
    utils.lib.eachDefaultSystem (
      system: let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {inherit system;};

        nvim =
          pkgs.wrapNeovimUnstable inputs.neovim-nightly-overlay.packages.${system}.neovim
          (pkgs.neovimUtils.makeNeovimConfig
            {
              customRC = ''
                set runtimepath^=${./.}
                source ${./init.lua}
              '';
              wrapperArgs = ''
                --suffix PATH : "${lib.makeBinPath (with pkgs; [
                  gcc
                  ripgrep
                  git

                  tree-sitter
                ])}"'';
              withNodeJs = true;
            });
      in {
        packages = rec {
          neovim = nvim;
          default = neovim;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            stylua
            lua-language-server
          ];
        };
      }
    );
}
