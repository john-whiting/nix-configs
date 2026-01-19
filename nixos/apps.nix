{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs = {
    firefox.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    [
      git
      vim
      wget
    ]
    ++ [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];
}
