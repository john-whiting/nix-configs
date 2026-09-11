{
  lib,
  config,
  withSystem,
  options,
  ...
}:
{
  options = {
    nixos = {
      modules = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
      };
    };
    hosts = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.singleLineStr;
                default = name;
              };
              modules = lib.mkOption {
                type = lib.types.listOf lib.types.deferredModule;
              };
              users = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      user = lib.mkOption {
                        type = options.users.type.nestedTypes.elemType;
                      };
                      extraGroups = lib.mkOption {
                        type = lib.types.listOf lib.types.singleLineStr;
                        default = [ ];
                      };
                      isNormalUser = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                      };
                      isAdmin = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                      };
                    };
                  }
                );
                default = [ ];
              };
            };
          }
        )
      );
    };
  };
  config = {
    flake.nixosConfigurations = builtins.mapAttrs (
      name: host:
      lib.nixosSystem {
        modules = [
          (
            nixosArgs@{ pkgs, ... }:
            {
              imports =
                host.modules
                ++ (with config.nixos.modules; [
                  core
                ]);

              networking.hostName = lib.mkDefault name;
              nixpkgs.pkgs = withSystem nixosArgs.config.hardware.facter.report.system (lib.getAttr "pkgs");

              assertions = [
                {
                  assertion =
                    let
                      names = map (u: u.user.name) host.users;
                    in
                    builtins.length names == builtins.length (lib.unique names);
                  message = "Host '${name}' has duplicate user entries in `hosts.${name}.users`.";
                }
              ];

              nix.settings.trusted-users = map (u: u.user.name) (lib.filter (u: u.isAdmin) host.users);

              users.users = lib.listToAttrs (
                map (u: {
                  name = u.user.name;
                  value = {
                    inherit (u) isNormalUser;
                    extraGroups = u.extraGroups ++ lib.optional u.isAdmin "wheel";
                    description = u.user.fullName;
                  }
                  // lib.optionalAttrs (u.user.shell != null) { shell = u.user.shell pkgs; }
                  // lib.optionalAttrs (u.user.initialHashedPassword != null) {
                    inherit (u.user) initialHashedPassword;
                  };
                }) host.users
              );
            }
          )
        ];
      }
    ) config.hosts;
  };
}
