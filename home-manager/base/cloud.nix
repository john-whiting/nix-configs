{
  pkgs,
  unstable,
  ...
}:
{
  home.packages = with pkgs; [
    # TODO: remove unstable when device-auth is fixed in stable
    unstable.azure-cli
  ];
}
