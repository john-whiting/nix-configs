{ config, ... }:
{
  nixos.modules.boot =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };

  nixos.modules.core = {
    imports = [ config.nixos.modules.boot ];
  };

  home.modules.core = {
    systemd.user.startServices = "sd-switch";
  };
}
