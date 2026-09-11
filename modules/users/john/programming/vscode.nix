{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "vscode"
    ];
  };

  home.user-modules.john.programming-gui =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        vscode
      ];
    };
}
