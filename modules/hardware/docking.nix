{
  nixos.modules.docking = {
    # Support thunderbolt
    services.hardware.bolt.enable = true;

    # TODO: Support another time
    # Support displaylink
    # nixpkgs.config.allowUnfreePackages = [ "displaylink" ];
    # specialisation.displaylink.configuration = {
    #   services.xserver.videoDrivers = [
    #     "displaylink"
    #     "modesetting"
    #   ];
    # };
  };
}
