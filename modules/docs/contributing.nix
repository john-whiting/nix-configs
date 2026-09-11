{ lib, ... }:
{
  perSystem =
    psArgs:
    let
      paths = psArgs.config.files.file |> lib.attrNames;
      generated = paths |> map (path: "`${path}`") |> lib.concatStringsSep ", ";
      generatedPlain = paths |> lib.concatStringsSep ", ";
    in
    {
      text.readme.parts.contributing =
        # markdown
        ''
          ## Contributing

          - **Add a module** — drop a `.nix` file anywhere under `modules/`. It is imported automatically.
            Only aggregate modules (`core`, `gui`, `base`, …) need an explicit entry in their `imports` list.
          - **Add a flake input** — declare it in the module that uses it, then regenerate `flake.nix`:

            ```nix
            flake-file.inputs.foo.url = "github:owner/foo";
            ```

            ```sh
            nix run .#write-flake
            ```

          - **Update inputs** — `nix flake update` (or `nix flake update <input>`).
          - **Format** — `nix run nixpkgs#nixfmt -- .`; 2-space indent, LF, trailing newline
            (see `.editorconfig`).
          - **Check before committing** — `nix flake check`, plus a build of whatever you touched.

          ### Generated files

          ${generated} and `flake.nix` are generated. Don't edit them; edit the modules that describe them
          and regenerate:

          ```sh
          nix run .#write-files   # ${generatedPlain}, from modules/docs/
          nix run .#write-flake   # flake.nix, from every flake-file.inputs declaration
          ```

          `nix flake check` fails when either is out of date.
        '';
    };
}
