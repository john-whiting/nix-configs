{
  home.modules.cloud =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        azure-cli
      ];
    };
}
