{ config, ... }:
{
  nixos.modules.browsers = {
    programs.firefox.enable = true;
  };

  nixos.modules.gui = {
    imports = [
      config.nixos.modules.browsers
    ];
  };

  flake.modules.home.browsers = {
    programs.firefox.enable = true;
  };
  flake.modules.home.gui = config.flake.modules.home.browsers;
}
