{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "obsidian"
    ];
  };

  home.user-modules.john.notetaking =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        obsidian
      ];
    };
}
