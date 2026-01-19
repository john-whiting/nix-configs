{ pkgs, lib, ... }:
{
  programs = {
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];
}
