{
  nixvim.user-modules.john.themes = {
    # If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
          styles = {
            comments = {
              italic = false;
            };
          };
        };
      };
    };
  };
}
