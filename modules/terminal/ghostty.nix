{ config, ... }:
{
  nixos.modules.terminal =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ghostty
      ];
    };

  nixos.modules.gui = {
    imports = [
      config.nixos.modules.terminal
    ];
  };
}
