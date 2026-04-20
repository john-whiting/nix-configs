{
  plugins.harpoon.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>a";
      action.__raw = ''function() require("harpoon"):list():add() end'';
      options = {
        desc = "[A]dd file to harpoon menu";
      };
    }
    {
      mode = "n";
      key = "<C-h>";
      action.__raw = ''
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end
      '';
      options = {
        desc = "Open [h]arpoon menu";
      };
    }

    {
      mode = "n";
      key = "<C-j>";
      action.__raw = ''
        function()
          require("harpoon"):list():select(1)
        end
      '';
      options = {
        desc = "Go to first harpoon item";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action.__raw = ''
        function()
          require("harpoon"):list():select(2)
        end
      '';
      options = {
        desc = "Go to second harpoon item";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action.__raw = ''
        function()
          require("harpoon"):list():select(3)
        end
      '';
      options = {
        desc = "Go to third harpoon item";
      };
    }
  ];
}
