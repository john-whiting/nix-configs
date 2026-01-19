{ lib, ... }:
{
  security.pam.services = {
    # Enable fingerprint authentication for sudo
    sudo.fprintAuth = lib.mkDefault true;

    # Enable fingerprint authentication for su
    su.fprintAuth = lib.mkDefault true;

    # Enable fingerprint authentication for screen unlock
    xscreensaver.fprintAuth = lib.mkDefault true;

    # WARNING: login.fprintAuth may break GDM password authentication
    # Only enable if you understand the risks:
    # login.fprintAuth = lib.mkDefault true;
  };
}
