{ inputs, ... }:
let
  secrets = inputs.john-nvim-secrets;
in
{
  flake-file.inputs.john-nvim-secrets.url = "git+ssh://git@github.jwhiting.dev/john-whiting/nix-secrets.git";

  home.user-modules.john.secrets =
    { config, ... }:
    {
      # SOPS admin key, decrypted by agenix at activation and linked to sops's default key location.
      age.secrets.sops-admin = {
        file = "${secrets}/sops-admin.agekey.age";
        path = "${config.xdg.configHome}/sops/age/keys.txt";
        mode = "600";
      };
    };
}
