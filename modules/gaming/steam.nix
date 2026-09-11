{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "steam"
      "steam-unwrapped"
    ];
  };

  nixos.modules.gaming =
    { lib, pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers   enable = true;
        gamescopeSession.enable = true;
      };

      # NOTE: https://github.com/NixOS/nixpkgs/issues/523200
      security.wrappers.bwrap = lib.mkForce {
        source = "${pkgs.bubblewrap}/bin/bwrap";
        owner = "root";
        group = "root";
        setuid = false;
        setgid = false;
      };
    };
}
