{
  lib,
  neovim,
  config,
}: let
  inherit (lib) mkOption mkEnableOption type;
  cfg = config.xun.small-nvim;
in {
  options.xun.small-nvim = {
    enable = mkEnableOption "neovim config";
    package = neovim;
    colorscheme = mkOption {
      type = type.str;
      default = "carbonfox";
      description = "which colorscheme to use";
      example = "dawnfox";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [neovim];
  };
}
