{ config, ... }:
{
  nixvim.user-modules.john.base = {
    imports = with config.nixvim.user-modules.john; [
      autopairs
      cmp
      conform
      debug
      git
      harpoon
      indent-utils
      linting
      lsp
      mini
      minuet
      multicursor
      neotree
      rustaceanvim
      secrets
      telescope
      todo-comments
      which-key
      auto
      clipboard
      diagnostics
      globals
      keymaps
      options
      themes
    ];
  };

  nixvimConfigurations.john-nvim = {
    modules = [ config.nixvim.user-modules.john.base ];
    system = "x86_64-linux";
    exposeHomeModule = true;
    exposeNixosModule = true;
  };
}
