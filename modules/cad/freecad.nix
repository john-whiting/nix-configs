{
  home.modules.cad =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.freecad
      ];
    };
}
