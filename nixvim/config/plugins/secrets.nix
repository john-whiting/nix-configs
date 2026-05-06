{
  config,
  ...
}:
{
  pkgs,
  ...
}:
let
  desired_secrets = [
    "api-ai-gemini"
    "api-ai-openai"
  ];
in
{
  extraConfigLua = ''
    function expand_env(str)
      str = str:gsub("%''${([%w_]+)}", os.getenv)
      str = str:gsub('%$([%w_]+)', os.getenv)

      return str
    end

    function get_agenix_secret(path)
      local file, _err = io.open(path, "r")

      if not file then
        return ""
      end

      local content = file:read("*all")
      file:close()

      return content:gsub("^%s*(.-)%s*$", "%1")
    end

    agenix_secrets = {}
    ${pkgs.lib.concatStringsSep "\n" (
      map (
        sec: "agenix_secrets['${sec}'] = get_agenix_secret(expand_env('${config.age.secrets.${sec}.path}'))"
      ) desired_secrets
    )}

  '';
}
