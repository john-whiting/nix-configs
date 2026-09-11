{ config, lib, ... }:
let
  baseFullName = config.users."john[cli]".fullName;
in
{
  home.user-modules.john-kv.cli = {
    imports = [
      {
        gitConfig.userEmail = "jwhiting@kinetic-vision.com";
      }
    ];
  };

  home.user-modules.john-kv.gui = {
    imports =
      with config.home.modules;
      with config.home.user-modules.john;
      [
        fonts
      ];
  };

  users."john[cli]@kv" = lib.mergeAttrsList [
    config.users."john[cli]"
    {
      name = "john-kv";
      fullName = "${baseFullName} (KV)";

      description = "CLI only, different git identity";

      email = "jwhiting@kinetic-vision.com";
    }
  ];

  users."john@kv" = config.users."john[cli]@kv" // {
    description = "CLI + GUI, different git identity";

    home.modules = config.users."john[cli]@kv".home.modules ++ [
      config.home.user-modules.john-kv.gui
    ];
  };
}
