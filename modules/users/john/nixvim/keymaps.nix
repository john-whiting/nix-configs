{
  nixvim.user-modules.john.keymaps = {
    keymaps = [
      {
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        mode = "v";
      }
      {
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        mode = "v";
      }

      {
        key = "<leader>p";
        action = ''"_dP'';
        mode = "v";
      }
      {
        key = "<leader>d";
        action = ''"_d'';
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>c";
        action = ''"_c'';
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>y";
        action = ''"+y'';
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>Y";
        action = ''"+Y'';
        mode = "n";
      }

      {
        key = "Q";
        action = "<nop>";
        mode = "n";
      }
      # Clear highlights on search when pressing <Esc> in normal mode
      #  See `:help hlsearch`
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
      # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
      # is not what someone will guess without a bit more experience.
      #
      # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
      # or just use <C-\><C-n> to exit terminal mode
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit terminal mode";
        };
      }
      # TIP: Disable arrow keys in normal mode
      /*
        {
          mode = "n";
          key = "<left>";
          action = "<cmd>echo 'Use h to move!!'<CR>";
        }
        {
          mode = "n";
          key = "<right>";
          action = "<cmd>echo 'Use l to move!!'<CR>";
        }
        {
          mode = "n";
          key = "<up>";
          action = "<cmd>echo 'Use k to move!!'<CR>";
        }
        {
          mode = "n";
          key = "<down>";
          action = "<cmd>echo 'Use j to move!!'<CR>";
        }
      */

    ];
  };
}
