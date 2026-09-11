{
  home.modules.networking =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bind
        net-tools
        tcpdump
        nmap
        openssl
      ];
    };
}
