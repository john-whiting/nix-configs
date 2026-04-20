{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        default_settings = {
          rust-analyzer = {
            check = {
              command = "clippy";
            };
          };
        };
        on_attach = ''
          function(client, bufnr)
            vim.keymap.set(
              "n",
              "K",
              function()
                vim.cmd.RustLsp({'hover', 'actions'})
              end,
              { silent = true, buffer = bufnr }
            )
          end
        '';
        standalone = true;
      };
    };
  };
}
