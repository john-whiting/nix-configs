{
  lib,
  config,
  inputs,
  ...
}:
{
  options.nixvimConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          modules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };
          exposeHomeModule = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          exposeNixosModule = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      }
    );
    default = { };
  };

  config =
    let
      flakeConfig = config;

      mkSecretsLua = hmConfig:
        let nixvimAgeSecrets = flakeConfig.nixvim.age.secrets; in
        lib.optionalString (nixvimAgeSecrets != { }) (
          ''
            function expand_env(str)
              str = str:gsub("%''${([%w_]+)}", os.getenv)
              str = str:gsub('%$([%w_]+)', os.getenv)
              return str
            end

            function get_agenix_secret(path)
              local file, _err = io.open(path, "r")
              if not file then return "" end
              local content = file:read("*all")
              file:close()
              return content:gsub("^%s*(.-)%s*$", "%%1")
            end

            agenix_secrets = {}
          ''
          + lib.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: _: "agenix_secrets['${name}'] = get_agenix_secret('${hmConfig.age.secrets.${name}.path}')"
            ) nixvimAgeSecrets
          )
        );

      mkWrappedModule = systemModule: cfg:
        { config, lib, ... }:
        {
          imports = [ systemModule ];
          age.secrets = lib.mapAttrs (_: sec: { inherit (sec) file; }) flakeConfig.nixvim.age.secrets;
          programs.nixvim = {
            enable = true;
            imports = cfg.modules;
            extraConfigLua = mkSecretsLua config;
          };
        };
    in
    {
      flake.packages = lib.foldl' lib.recursiveUpdate { } (
        lib.mapAttrsToList (name: cfg: {
          ${cfg.system}.${name} =
            inputs.nixvim.legacyPackages.${cfg.system}.makeNixvimWithModule {
              module = {
                imports = cfg.modules;
              };
            };
        }) config.nixvimConfigurations
      );

      home.modules = lib.mapAttrs (
        _: cfg: mkWrappedModule inputs.nixvim.homeModules.nixvim cfg
      ) (lib.filterAttrs (_: cfg: cfg.exposeHomeModule) config.nixvimConfigurations);

      nixos.modules = lib.mapAttrs (
        _: cfg: mkWrappedModule inputs.nixvim.nixosModules.nixvim cfg
      ) (lib.filterAttrs (_: cfg: cfg.exposeNixosModule) config.nixvimConfigurations);
    };
}
