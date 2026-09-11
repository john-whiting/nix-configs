{
  home.user-modules.john.zsh = {
    programs.zsh.initContent = ''
      # Use familiar "emacs"-like keybinds
      bindkey -e

      # Control + backspace and Control + delete
      bindkey '^H' backward-kill-word
      bindkey '5~' kill-word

      # CTRL + Arrow Left/Right
      bindkey ";5C" forward-word
      bindkey ";3C" forward-word
      bindkey ";5D" backward-word
      bindkey ";3D" backward-word

      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^X^e' edit-command-line
    '';
  };
}
