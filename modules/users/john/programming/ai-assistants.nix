{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "chatgpt"
      "claude-code"
    ];
  };

  home.user-modules.john.programming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        opencode
        claude-code
        codex
      ];
    };
}
