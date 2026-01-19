{
  keymaps = [
    {
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      mode = "n";
    }
    {
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      mode = "n";
    }

    {
      key = "<leader>p";
      action = ''"_dP'';
      mode = "n";
    }
    {
      key = "<leader>d";
      action = ''"_d'';
      mode = "n";
    }
    {
      key = "<leader>c";
      action = ''"_c'';
      mode = "n";
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
  ];
}
