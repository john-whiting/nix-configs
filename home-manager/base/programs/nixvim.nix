{ inputs, ... }:
{
  imports = [
    inputs.nixvim-config.homeManagerModules.default
  ];

  programs.nixvim.enable = true;
}
