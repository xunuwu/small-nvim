{inputs}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.xun.small-nvim;
  inherit (lib) mkEnableOption mkOption types;
in {
  options.xun.small-nvim = {
    enable = mkEnableOption "neovim config";
    wakatime.enable = mkEnableOption "wakatime plugin";
    colorscheme = {
      name = mkOption {
        type = types.str;
        default = "carbonfox";
        description = "which colorscheme to use";
        example = "dawnfox";
      };
      package = mkOption {
        type = types.str;
        default = "EdenEast/nightfox.nvim";
        description = "colorscheme package name";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "extra colorscheme configuration in lua";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.callPackage ./package.nix {
        inherit (inputs.neovim-nightly-overlay.packages.${pkgs.system}) neovim;
        conf = builtins.toFile "config.lua" ''
          _G.CONFIG = {
            colorscheme = {
               name = "${cfg.colorscheme.name}",
               package = "${cfg.colorscheme.package}",
               extraConfig = "${builtins.toFile "extraConfig.lua" cfg.colorscheme.extraConfig}",
            },
            wakatime = ${lib.boolToString cfg.wakatime.enable},
          }
        '';
      })
    ];
    home.sessionVariables.EDITOR = "nvim";
  };
}
