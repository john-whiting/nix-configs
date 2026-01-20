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
    markdownlint-cli2 # needed for markdown files in neovim
    vscode
  ];
}
