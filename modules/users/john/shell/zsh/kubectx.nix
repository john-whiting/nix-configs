{
  home.user-modules.john.zsh = {
    programs.zsh = {
      initContent = ''
        kubectx() {
          kubectl config use-context $(kubectl config get-contexts -o name | fzf)
        }
      '';
    };
  };
}
