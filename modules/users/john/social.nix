{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "discord"
      "discord-unwrapped"
    ];
  };

  home.user-modules.john.social =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        discord
      ];
    };
}
