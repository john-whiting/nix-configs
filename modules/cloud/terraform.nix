{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "terraform"
    ];
  };

  home.modules.cloud =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        terraform
      ];
    };
}
