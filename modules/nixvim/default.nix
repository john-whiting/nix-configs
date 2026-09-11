{
  lib,
  ...
}:
{
  options = {
    nixvim = {
      modules = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
      };
      user-modules = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
      };
      age.secrets = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.file = lib.mkOption { type = lib.types.path; };
        });
        default = { };
      };
    };
  };
  config = {
    flake-file.inputs.nixvim.url = "github:nix-community/nixvim";
  };
}
