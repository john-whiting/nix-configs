{ config, ... }:
{
  home.user-modules.john.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.gitConfig = {
        userName = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "John Whiting";
          description = "Username to be used in git commits";
        };
        userEmail = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "john@jwhiting.dev";
          description = "Email to be used in git commits";
        };

        defaultBranchName = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "main";
          description = "Name for the default branch";
        };
      };

      config = {
        programs.git = {
          enable = true;

          settings = {
            user = {
              name = config.gitConfig.userName;
              email = config.gitConfig.userEmail;
            };
            init.defaultBranch = config.gitConfig.defaultBranchName;
          };

          lfs.enable = true;
        };

        home.packages = with pkgs; [
          # gitbutler
        ];
        programs.zsh = {
          shellAliases = {
            "git-remove-untracked" =
              ''git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'';
          };

          zplug = {
            plugins = [
              {
                name = "plugins/git";
                tags = [ "from:oh-my-zsh" ];
              }
            ];
          };
        };
      };
    };
}
