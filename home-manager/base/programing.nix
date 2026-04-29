{
  pkgs,
  unstable,
  ...
}:
{
  imports = [
    ./programs/nixvim.nix
    ./programs/git.nix
  ];

  home.packages = with pkgs; [
    unstable.devenv
    unstable.opencode
    openssl
    markdownlint-cli2 # needed for markdown files in neovim
    (writeShellScriptBin "markdownlint" ''
      exec ${markdownlint-cli2}/bin/markdownlint-cli2 "$@"
    '')
    vscode
  ];
}
