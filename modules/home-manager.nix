{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
{
  options = {
    home = {
      modules = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
      };
      user-modules = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
      };
    };
  };
  config = {
    flake-file.inputs.home-manager.url = "github:nix-community/home-manager";
    home.modules.core = {
      programs.home-manager.enable = true;
    };

    flake.homeConfigurations = lib.listToAttrs (
      lib.concatMap (
        system:
        lib.mapAttrsToList (name: user: {
          name = "${name}@${system}";
          value = withSystem system (
            { pkgs, ... }:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                {
                  home.username = user.name;
                  home.homeDirectory = "/home/${user.name}";
                  imports =
                    user.home.modules
                    ++ (with config.home.modules; [
                      core
                    ]);
                }
              ];
            }
          );
        }) config.users
      ) config.systems
    );
  };
}
