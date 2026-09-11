{ config, ... }:
{
  nixos.modules.de-cosmic = {
    services = {
      # Enable the COSMIC login manager
      displayManager.cosmic-greeter.enable = true;

      # Enable the COSMIC desktop environment
      desktopManager.cosmic.enable = true;

      # Use system76's scheduler to improve performance
      system76-scheduler.enable = true;
    };

    # Allow the clipboard to work between applications
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      # this let's it pick up on Cosmic's theme
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  nixos.modules.gui = {
    imports = [
      config.nixos.modules.de-cosmic
    ];
  };
}
