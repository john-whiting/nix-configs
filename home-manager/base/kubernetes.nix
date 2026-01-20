{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kubernetes-helm
    k9s
    kubectl
    kubelogin
    kyverno
  ];
}
