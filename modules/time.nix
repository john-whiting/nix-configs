{ config, ... }:
{
  nixos.modules.time = {
    services.automatic-timezoned.enable = true;
  };

  nixos.modules.core = {
    imports = [
      config.nixos.modules.time
    ];
  };
}
