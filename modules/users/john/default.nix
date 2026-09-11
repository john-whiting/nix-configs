{ config, ... }:
{
  home.user-modules.john.cli = {
    imports =
      with config.home.modules;
      with config.home.user-modules.john;
      [
        cloud
        git
        networking
        programming
        shell
        secrets
      ];

    home.stateVersion = "25.05";
  };

  home.user-modules.john.gui = {
    imports =
      with config.home.modules;
      with config.home.user-modules.john;
      [
        cad
        fonts
        notetaking
        programming-gui
        social
      ];
  };

  users."john[cli]" = {
    name = "john";

    description = "CLI only — shell, git, programming, cloud, networking, secrets";

    fullName = "John Whiting";
    email = "john@jwhiting.dev";

    shell = pkgs: pkgs.zsh;

    home.modules = [
      config.home.user-modules.john.cli
    ];
  };

  users.john = config.users."john[cli]" // {
    description = "CLI + GUI — browsers, fonts, CAD, notetaking, social";

    home.modules = config.users."john[cli]".home.modules ++ [
      config.home.user-modules.john.gui
    ];
  };
}
