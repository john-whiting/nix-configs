{
  home.user-modules.john.secrets =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        age
      ];
    };
}
