{
  config,
  ...
}:
{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        path = "${config.xdg.stateHome}/zsh/history";
        save = 10000;
      };

      shellAliases = {
        # `cd` should use zoxide
        "cd" = "z";
        "cdi" = "zi";

        # List aliases
        "ls" = "ls --color";
        "ll" = "ls -alF";
        "la" = "ls -A";
        "l" = "ls -CF";

        # Git
        "git-remove-untracked" =
          ''git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'';

        # Neovim
        "nv" = "nvim -p";

        # Markdown lint
        "markdownlint" = "markdownlint-cli2";
      };

      zplug = {
        enable = true;
        plugins = [
          {
            name = "plugins/git";
            tags = [ "from:oh-my-zsh" ];
          }
        ];
        zplugHome = "${config.xdg.stateHome}/zplug";
      };

      initExtra = ''
        eval "$(zoxide init zsh)"
        eval "$(mise activate zsh)"

        # Control + backspace and Control + delete
        bindkey '^H' backward-kill-word
        bindkey '5~' kill-word

        # CTRL + Arrow Left/Right
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word

        autoload edit-command-line
        zle -N edit-command-line
        bindkey '^X^e' edit-command-line

        devc () {
          compose_file=$(find .devcontainer -regex '.*/docker-compose.ya?ml')
          compose_file_data=$(docker compose -f "$compose_file" config 2> /dev/null)

          if [[ "$1" = "code" ]]
          then
            container_name="$2"
            if [[ -z "$container_name" ]]
            then
              # Strip some comments from the JSON file, then get service.
              # Your mileage may vary.
              service_name=$(cat .devcontainer/devcontainer.json | awk '{ if ($0 ~ /^\s*\/\//) { next }; gsub(/\/\/.*$/, ""); print }' | yq '.service' -r)
              container_name=$(echo "$compose_file_data" | yq ".services[\"$service_name\"].container_name" -r)
              echo "Found service '$service_name' with container name '$container_name'"
            fi
            container_state=$(docker ps -a --filter name="$container_name" --format=json | yq '.State' -r)
            if [[ -z "$container_state" ]]
            then
              read -q "RUN_UP?It looks like this container hasn't been created yet. Would you like to? [yN] "
              if [ "$RUN_UP" = "y" ]
              then
                docker compose -f "$compose_file" up -d
              else
                return 0
              fi
            elif [[ "$container_state" = "exited" ]]
            then
              echo "Restarting stopped containers..."
              docker compose -f "$compose_file" start
            fi
            container_json="$(echo -n "{\"containerName\":\"$container_name\"}" | xxd -ps -c 128)"
            workspace_path=''${3:="workspace"}
            folder_uri="vscode-remote://attached-container+$container_json/$workspace_path"
            echo "Attaching to '$folder_uri'..."
            code --folder-uri=$folder_uri
          else
            docker compose -f "$compose_file" $@
          fi
        }

        kubectx() {
          kubectl config use-context $(kubectl config get-contexts -o name | fzy)
        }
      '';
    };
  };
}
