{
  home.user-modules.john.programming =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        devenv
      ];

      programs.zsh.initContent = lib.mkBefore ''
        eval "$(devenv hook zsh)"
      '';
    };
}
