{
  nixos.modules.gaming = {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
