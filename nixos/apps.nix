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
}
