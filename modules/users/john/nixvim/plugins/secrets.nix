{ inputs, ... }:
let
  secrets = inputs.john-nvim-secrets;
in
{
  flake-file.inputs.john-nvim-secrets.url = "git+ssh://git@github.jwhiting.dev/john-whiting/nix-secrets.git";

  # Secrets declared here are bridged into age.secrets by the nixvim generator,
  # making them available as agenix_secrets['name'] in all nixvim Lua config.
  nixvim.age.secrets.api-ai-gemini.file = "${secrets}/api-ai-gemini.age";
  nixvim.age.secrets.api-ai-openai.file = "${secrets}/api-ai-openai.age";

  nixvim.user-modules.john.secrets = { };
}
