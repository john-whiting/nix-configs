{ config, lib, ... }:
let
  configs = lib.attrNames config.users;

  table =
    config.users
    |> lib.mapAttrsToList (name: user: "| `${name}` | ${user.description} |")
    |> lib.concatLines;

  systems = config.systems |> map (s: "`${s}`") |> lib.concatStringsSep ", ";

  permutations =
    lib.concatMap (name: map (system: "- `${name}@${system}`") config.systems) configs
    |> lib.concatLines;

  example = lib.head configs;
in
{
  perSystem.text.readme.parts.home-manager =
    # markdown
    ''
      ## Home Manager

      `homeConfigurations` are named `<config>@<system>`.

      | Config | Contents |
      | --- | --- |
      ${table}
      Systems: ${systems}.

      Quote the fragment — the names contain `[`, `]` and `@`.

      ```sh
      # activate
      home-manager switch --flake '.#${example}@x86_64-linux'

      # build without activating
      nix build '.#homeConfigurations."${example}@x86_64-linux".activationPackage'
      ./result/activate
      ```

      <details>
      <summary>All ${
        toString (lib.length configs * lib.length config.systems)
      } home configurations</summary>

      ${permutations}
      </details>

    '';
}
