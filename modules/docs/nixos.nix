{ config, lib, ... }:
let
  table =
    config.hosts
    |> lib.mapAttrsToList (
      name: host:
      let
        users = host.users |> map (u: "`${u.user.name}`") |> lib.concatStringsSep ", ";
      in
      "| `${name}` | ${host.description} | ${users} |"
    )
    |> lib.concatLines;

  example = lib.head (lib.attrNames config.hosts);
in
{
  perSystem.text.readme.parts.nixos =
    # markdown
    ''
      ## NixOS

      `nixosConfigurations` are named after the host.

      | Host | Machine | Users |
      | --- | --- | --- |
      ${table}
      ```sh
      # activate
      sudo nixos-rebuild switch --flake .#${example}

      # build / preview only
      nixos-rebuild build --flake .#${example}
      nixos-rebuild dry-activate --flake .#${example}
      ```

      A host's `users` entry creates the system account only. Home Manager is activated separately,
      with the commands above.

    '';
}
