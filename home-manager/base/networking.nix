{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bind
    net-tools
    tcpdump
    nmap
  ];
}
