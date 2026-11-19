{
  home.user-modules.john.zsh = {
    programs.zsh = {
      initContent = ''
        # azsub: switch the active subscription within the current az context.
        # The selection is stored by az itself, so it's per azctx context.
        azsub() {
          local cfg="''${AZURE_CONFIG_DIR:-$HOME/.azure}"
          local current
          current="$(az account show --query name -o tsv 2>/dev/null)"

          case "$1" in
            -h|--help)
              echo "usage: azsub                pick a subscription with fzf"
              echo "       azsub <name|id>      switch to a subscription"
              echo "       azsub -              switch to the previous subscription"
              echo "       azsub -c             print the current subscription"
              echo "       azsub -l             list subscriptions"
              return 0 ;;
            -c) echo "$current"; return 0 ;;
            -l) az account list --query "[].name" -o tsv; return 0 ;;
          esac

          local target="$1"
          if [[ "$target" == "-" ]]; then
            target="$(cat "$cfg/.azsub_previous" 2>/dev/null)"
            [[ -z "$target" ]] && { echo "azsub: no previous subscription" >&2; return 1; }
          elif [[ -z "$target" ]]; then
            # name <tab> id; show both, select by id so duplicate names are fine.
            target="$(az account list --query "[].[name, id]" -o tsv \
              | fzf --delimiter=$'\t' --prompt="azsub ($current)> " \
              | cut -f2)" || return 1
            [[ -z "$target" ]] && return 1
          fi

          az account set --subscription "$target" || return 1
          [[ -n "$current" ]] && echo "$current" > "$cfg/.azsub_previous"
          echo "azsub: switched to '$(az account show --query name -o tsv)'" >&2
        }

        _azsub() {
          local -a subs
          subs=("''${(@f)$(az account list --query "[].name" -o tsv 2>/dev/null)}")
          compadd -a subs
        }
        compdef _azsub azsub
      '';
    };
  };
}
