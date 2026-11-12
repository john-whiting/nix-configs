{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "chatgpt"
    ];
  };

  home.user-modules.john.programming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        opencode
        codex
      ];
    };
}
