{
  home.user-modules.john.zsh = {
    programs.zsh = {
      initContent = ''
        # azctx: swap between az cli config dirs (each one keeps its own login).
        # Contexts live in $AZCTX_HOME/<name>; "default" means the stock ~/.azure.
        AZCTX_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}/azctx"

        # Restore the last selected context in new shells.
        if [[ -r "$AZCTX_HOME/.current" ]]; then
          _azctx_name="$(<"$AZCTX_HOME/.current")"
          [[ -d "$AZCTX_HOME/$_azctx_name" ]] && export AZURE_CONFIG_DIR="$AZCTX_HOME/$_azctx_name"
          unset _azctx_name
        fi

        azctx() {
          local current="''${''${AZURE_CONFIG_DIR:t}:-default}"

          case "$1" in
            -h|--help)
              echo "usage: azctx            pick a context with fzf"
              echo "       azctx <name>     switch to (or create) a context"
              echo "       azctx -          switch to the previous context"
              echo "       azctx -c         print the current context"
              echo "       azctx -l         list contexts"
              return 0 ;;
            -c) echo "$current"; return 0 ;;
            -l) print -l default "$AZCTX_HOME"/*(/N:t); return 0 ;;
          esac

          local target="$1"
          if [[ "$target" == "-" ]]; then
            target="$(cat "$AZCTX_HOME/.previous" 2>/dev/null)"
            [[ -z "$target" ]] && { echo "azctx: no previous context" >&2; return 1; }
          elif [[ -z "$target" ]]; then
            target="$(azctx -l | fzf --prompt="azctx ($current)> ")" || return 1
          fi

          mkdir -p "$AZCTX_HOME"
          [[ "$target" != "$current" ]] && echo "$current" > "$AZCTX_HOME/.previous"

          if [[ "$target" == "default" ]]; then
            unset AZURE_CONFIG_DIR
            rm -f "$AZCTX_HOME/.current"
          else
            if [[ ! -d "$AZCTX_HOME/$target" ]]; then
              mkdir -p "$AZCTX_HOME/$target"
              echo "azctx: created new context '$target' (run 'az login')" >&2
            fi
            export AZURE_CONFIG_DIR="$AZCTX_HOME/$target"
            echo "$target" > "$AZCTX_HOME/.current"
          fi
          echo "azctx: switched to '$target'" >&2
        }

        _azctx() { compadd - default "$AZCTX_HOME"/*(/N:t) }
        compdef _azctx azctx
      '';
    };
  };
}
