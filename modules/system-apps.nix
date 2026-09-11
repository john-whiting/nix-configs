{ config, ... }:
{
  nixos.modules.system-apps =
    { pkgs, ... }:
    {

      environment.systemPackages = with pkgs; [
        git
        vim
        wget
      ];
    };

  nixos.modules.core = {
    imports = [
      config.nixos.modules.system-apps
    ];
  };
}
