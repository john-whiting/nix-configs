{
  lib,
  ...
}:
{
  options = {
    users = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.singleLineStr;
                default = name;
              };
              fullName = lib.mkOption {
                type = lib.types.singleLineStr;
                default = name;
              };
              email = lib.mkOption {
                type = lib.types.nullOr lib.types.singleLineStr;
              };
              shell = lib.mkOption {
                type = lib.types.nullOr (lib.types.functionTo lib.types.package);
                default = null;
              };
              initialHashedPassword = lib.mkOption {
                type = lib.types.nullOr lib.types.singleLineStr;
                default = null;
              };
              home = lib.mkOption {
                type = lib.types.submodule {
                  options.modules = lib.mkOption {
                    type = lib.types.listOf lib.types.deferredModule;
                  };
                };
              };
            };
          }
        )
      );
    };
  };
}
