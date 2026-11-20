{
  perSystem = {
    nixpkgs.config.allowUnfreePackages = [
      "claude-code"
      "acli"
      "acli-unwrapped"
    ];
  };

  home.user-modules.john.programming =
    { pkgs, ... }:
    let
      jira-issue = pkgs.writeShellApplication {
        name = "jira-issue";
        runtimeInputs = with pkgs; [
          acli
          jq
        ];
        # Prints a Jira issue as markdown: summary, metadata, description, text custom fields,
        # subtasks and comments.
        text = ''
          if [ $# -ne 1 ]; then
            echo "usage: jira-issue <KEY-123 | https://<site>/browse/KEY-123>" >&2
            exit 2
          fi

          key=$(grep -oiE '[A-Z][A-Z0-9_]+-[0-9]+' <<<"$1" | tail -n1 | tr '[:lower:]' '[:upper:]' || true)
          if [ -z "$key" ]; then
            echo "jira-issue: no issue key in '$1'" >&2
            exit 2
          fi

          acli jira workitem view "$key" --json --fields '*all' | jq -r -f ${./jira-issue.jq}
        '';
      };
    in
    {
      home.packages = [
        pkgs.acli
        jira-issue
      ];

      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
        plugins.jw = ./jw;
        context = ./CLAUDE.md;
      };
    };
}
