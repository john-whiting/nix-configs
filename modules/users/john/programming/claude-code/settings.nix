{
  # Rendered to ~/.claude/settings.json by home-manager's programs.claude-code module.
  home.user-modules.john.programming = {
    programs.claude-code.settings = {
      theme = "dark";

      permissions.allow = [
        "Bash(git commit:*)"
        "Bash(git add:*)"
      ];

      enabledPlugins = {
        "typescript-lsp@claude-plugins-official" = true;
      };

      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
        network.allowedDomains = [
          "registry.npmjs.org"
          "github.com"
          "binaries.prisma.sh"
        ];
      };
    };
  };
}
