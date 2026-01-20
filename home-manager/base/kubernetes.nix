{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kubectl
    kubelogin
    k9s
  ];
}
