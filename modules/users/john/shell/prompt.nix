{ config, ... }:
{
  home.user-modules.john.prompt = {
    programs.starship.enable = true;
    programs.starship.enableZshIntegration = true;
  };

  home.user-modules.john.shell = {
    imports = [
      config.home.user-modules.john.prompt
    ];
  };
}
