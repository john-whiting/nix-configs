{ inputs, config, ... }:
{
  flake-file.inputs.ragenix.url = "github:yaxitech/ragenix";

  nixos.modules.secrets =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      imports = [
        inputs.ragenix.nixosModules.default
      ];

      environment.systemPackages = [
        inputs.ragenix.packages.${system}.default
      ];
    };

  nixos.modules.core = {
    imports = [
      config.nixos.modules.secrets
    ];
  };

  home.modules.secrets =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      imports = [
        inputs.ragenix.homeManagerModules.default
      ];

      home.packages = [
        inputs.ragenix.packages.${system}.default
      ];
    };

  home.modules.core = {
    imports = [
      config.home.modules.secrets
    ];
  };
}
