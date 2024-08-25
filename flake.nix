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

        nvim = pkgs.callPackage ./package.nix {
          inherit (inputs.neovim-nightly-overlay.packages.${system}) neovim;
        };
      in {
        packages = rec {
          neovim = nvim;
          default = neovim;
        };

        homeManagerModules.default = import ./hm-module.nix {inherit nvim;};
        # nixosModules.default = import ./hm-module.nix;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            stylua
            lua-language-server
          ];
        };
      }
    );
}
