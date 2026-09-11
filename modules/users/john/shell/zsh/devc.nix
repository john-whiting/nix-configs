{
  home.user-modules.john.zsh = {
    programs.zsh = {
      initContent = ''
        devc () {
          compose_file=$(find .devcontainer -regextype posix-extended -regex '.*\/(docker-)?compose.ya?ml')

          if [[ -z $compose_file ]]
          then
            echo "Unable to find devcontainer compose file." >&2
            return 1
          fi

          compose_file_data=$(docker compose -f "$compose_file" config 2> /dev/null)

          # Strip some comments from the JSON file
          # Your mileage may vary.
          devcontainer_json_data=$(cat .devcontainer/devcontainer.json | awk '{ if ($0 ~ /^\s*\/\//) { next }; gsub(/\/\/.*$/, ""); print }')

          if [[ "$1" = "code" ]]
          then
            container_name="$2"
            if [[ -z "$container_name" ]]
            then
              service_name=$(echo "$devcontainer_json_data" | yq '.service' -r)
              if [[ -z "$service_name" || "$service_name" = "null" ]]
              then
                echo "Unable to find service in devcontainer.json." >&2
                return 2
              fi

              project_name=$(echo "$compose_file_data" | yq ".name" -r)
              if [[ -z "$project_name" || "$project_name" = "null" ]]
              then
                project_name=""
              else
                project_name="$project_name-"
              fi

              container_name=$(echo "$compose_file_data" | yq ".services[\"$service_name\"].container_name" -r)
              if [[ -z "$container_name" || "$container_name" = "null" ]]
              then
                container_name="$project_name$service_name-1"
              fi

              echo "Found service '$service_name' with container name '$container_name'" >&2
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
              echo "Restarting stopped containers..." >&2
              docker compose -f "$compose_file" start
            fi
            container_json="$(echo -n "{\"containerName\":\"$container_name\"}" | xxd -ps -c 128)"
            workspace_path=''${3:="workspace"}
            folder_uri="vscode-remote://attached-container+$container_json/$workspace_path"
            echo "Attaching to '$folder_uri'..." >&2
            code --folder-uri=$folder_uri
          else
            docker compose -f "$compose_file" $@
          fi
        }
      '';
    };
  };
}
