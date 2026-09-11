{ config, ... }:
{
  home.user-modules.john.zsh =
    { config, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        dotDir = "${config.xdg.configHome}/zsh";

        history = {
          path = "${config.xdg.stateHome}/zsh/history";
          save = 10000;
        };

        shellAliases = {
          # List aliases
          "ls" = "ls --color";
          "ll" = "ls -alF";
          "la" = "ls -A";
          "l" = "ls -CF";
        };

        zplug = {
          enable = true;
          zplugHome = "${config.xdg.stateHome}/zplug";
        };

        initContent = lib.mkOrder 1 ''
          # Activate nix single-user mode
          if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
            . "$HOME/.nix-profile/etc/profile.d/nix.sh"
          fi
        '';
      };
    };

  home.user-modules.john.shell = {
    imports = [
      config.home.user-modules.john.zsh
    ];
  };
}
