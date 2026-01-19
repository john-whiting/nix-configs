{
  pkgs,
  ...
}:
{
  imports = [
    ./programs/nixvim.nix
    ./programs/git.nix
  ];

  home.packages = with pkgs; [
    vscode
  ];
}
