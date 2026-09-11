{ inputs, lib, ... }:
{
  imports = [ "${inputs.files}/flake-module.nix" ];

  flake-file.inputs.files = {
    url = "github:mightyiam/files";
    flake = false;
  };

  # A `text.<name>` is either a plain string or a set of named `parts` rendered
  # in an explicit `order`, which lets any module contribute a section.
  perSystem = _: {
    options.text = lib.mkOption {
      default = { };
      type = lib.types.lazyAttrsOf (
        lib.types.oneOf [
          (lib.types.separatedString "")
          (lib.types.submodule {
            options = {
              parts = lib.mkOption { type = lib.types.lazyAttrsOf lib.types.str; };
              order = lib.mkOption { type = lib.types.listOf lib.types.str; };
            };
          })
        ]
      );
      apply = lib.mapAttrs (
        _: text:
        if lib.isAttrs text then
          text.order |> map (lib.flip lib.getAttr text.parts) |> lib.concatStrings
        else
          text
      );
    };

    config.files.writer.app = true;
  };
}
