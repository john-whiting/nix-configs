{ config, ... }:
{
  home.user-modules.john.programming =
    { pkgs, lib, ... }:
    {
      imports = [ config.home.modules.john-nvim ];

      home.packages = with pkgs; [
        markdownlint-cli2
        (writeShellScriptBin "markdownlint" ''
          exec ${markdownlint-cli2}/bin/markdownlint-cli2 "$@"
        '')
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      programs.zsh.shellAliases = {
        "nv" = "nvim -p";
      };
    };
}
