{ config, lib, ... }:
let
  table =
    config.nixvimConfigurations
    |> lib.mapAttrsToList (
      name: cfg:
      let
        cell = exposed: tree: if exposed then "`${tree}.modules.${name}`" else "—";
      in
      "| `${name}` | `${cfg.system}` | ${cell cfg.exposeHomeModule "home"} | ${cell cfg.exposeNixosModule "nixos"} |"
    )
    |> lib.concatLines;

  example = lib.head (lib.attrNames config.nixvimConfigurations);

  moduleList =
    config.nixvim.user-modules
    |> lib.mapAttrsToList (
      user: modules:
      "- `${user}`: ${
        modules
        |> lib.attrNames
        |> map (m: "`${m}`")
        |> lib.concatStringsSep ", "
      }"
    )
    |> lib.concatLines;

  secrets =
    config.nixvim.age.secrets
    |> lib.attrNames
    |> map (s: "`${s}`")
    |> lib.concatStringsSep ", ";
in
{
  perSystem.text.readme.parts.nixvim =
    # markdown
    ''
      ## Nixvim

      Each `nixvimConfigurations.<name>` is exposed as a package, and optionally as a Home Manager
      and/or NixOS module.

      | Config | System | Home module | NixOS module |
      | --- | --- | --- | --- |
      ${table}
      ```sh
      nix run .#${example}
      ```

      The home module is already imported by `home.user-modules.john.programming`, so every `john*`
      home configuration ships it.

      ### Modules

      ${moduleList}
      `base` is the aggregate; the rest live under `modules/users/<user>/nixvim/`.

      ### Adding a plugin

      Create `modules/users/john/nixvim/plugins/<name>.nix`:

      ```nix
      {
        nixvim.user-modules.john.<name> = {
          plugins.<name>.enable = true;
        };
      }
      ```

      Then add `<name>` to the `imports` list in `modules/users/john/nixvim/default.nix`.

      ### Secrets

      An age file declared under `nixvim.age.secrets` is bridged into `age.secrets` and decrypted at
      runtime into the Lua global `agenix_secrets`. Declared: ${secrets}.

      ```nix
      nixvim.age.secrets.api-ai-gemini.file = "''${inputs.john-nvim-secrets}/api-ai-gemini.age";
      ```

      ```nix
      api_key.__raw = '''function() return agenix_secrets["api-ai-gemini"] end''';
      ```

    '';
}
