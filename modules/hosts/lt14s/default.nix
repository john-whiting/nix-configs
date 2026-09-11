{ config, ... }:
{
  nixos.modules.lt14s = {
    imports = with config.nixos.modules; [
      gui
      docking
      gaming
      networking
      discovery
      printing
      fprint
      audio
      virtualization
      shell
      flipper
    ];

    hardware.facter.reportPath = ./facter.json;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c950e196-87cf-4abf-af26-2df0999f3440";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/2841-C471";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    system.stateVersion = "25.05";

  };

  hosts.lt14s = {
    modules = [ config.nixos.modules.lt14s ];
    users = [
      {
        user = config.users.john;
        isAdmin = true;
        extraGroups = [
          "networkmanager"
          "docker"
        ];
      }
      {
        user = config.users."john@kv";
        isAdmin = true;
        extraGroups = [
          "networkmanager"
          "docker"
        ];
      }
    ];
  };
}
