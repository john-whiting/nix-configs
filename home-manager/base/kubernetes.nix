{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    k9s
    kubectl
    kubelogin
    kyverno
  ];
}
