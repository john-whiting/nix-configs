{
  lib,
  config,
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
  };
}
