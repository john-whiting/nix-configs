{
  config,
  inputs,
  lib,
  ...
}:

let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  flake-file.nixConfig.extra-experimental-features = [ "pipe-operators" ];

  nixos.modules.nix =
    {
      config,
      lib,
      ...
    }:
    {

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          nix-path = config.nix.nixPath;

          # Opinionated: disable global registry
          flake-registry = "";
        };

        # Opinionated: disable channels
        channel.enable = false;

        # Opinionated: make flake registry and nix path match flake inputs
        registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      };
    };

  nixos.modules.core = {
    imports = [
      config.nixos.modules.nix
    ];
  };
}
