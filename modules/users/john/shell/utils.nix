{ lib, ... }:
{
  home.user-modules.john.shell =
    { pkgs, ... }:
    {
      programs.zoxide.enable = true;
      programs.zsh.shellAliases = {
        "cd" = "z";
        "cdi" = "zi";
      };
      programs.zsh = {
        initContent = lib.mkBefore ''
          eval "$(zoxide init zsh)"
        '';
      };

      programs.btop.enable = true;
      programs.ripgrep.enable = true;
      programs.jq.enable = true;
      programs.fzf.enable = true;

      home.packages = with pkgs; [
        yq-go
      ];
    };
}
