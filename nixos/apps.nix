{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    [
      git
      vim
      wget
    ]
    ++ [
      inputs.ragenix.packages.${system}.default
      inputs.ghostty.packages.${system}.default
    ];

  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  # Gaming
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
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
}
