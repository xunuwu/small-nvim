{
  description = "xun's neovim config";

  inputs = {
    nixpkgs.url = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {inherit system;};
        inherit (pkgs) lib;

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
