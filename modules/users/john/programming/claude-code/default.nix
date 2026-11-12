{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "claude-code"
    ];
  };

  home.user-modules.john.programming =
    { pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
      };
    };
}
