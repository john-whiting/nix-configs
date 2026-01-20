# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./base/cloud.nix
    ./base/kubernetes.nix
    ./base/minimum.nix
    ./base/programing.nix
    ./base/social.nix
  ];

  home = {
    username = "john";
    homeDirectory = "/home/john";
  };
}
