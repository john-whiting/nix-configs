{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "discord"
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
