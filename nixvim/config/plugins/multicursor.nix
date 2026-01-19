{
  plugins.multicursors = {
    enable = true;
  };

  keymaps = [
    {
      key = "<leader>M";
      action = "<cmd>MCstart<CR>";
      mode = [
        "v"
        "n"
      ];
    }
  ];
}
