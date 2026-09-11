{
  nixvim.user-modules.john.globals = {
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html#globals
    globals = {
      # Set <space> as the leader key
      # See `:help mapleader`
      mapleader = " ";
      maplocalleader = " ";

      # Set to true if you have a Nerd Font installed and selected in the terminal
      have_nerd_font = false;
    };
  };
}
