{
  nixos.modules.virtualization =
    { lib, pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      systemd.services.docker.wantedBy = lib.mkForce [ ];

      virtualisation.libvirtd = {
        enable = true;
        qemu.swtpm.enable = true; # emulated TPM 2.0, required by Windows 11
      };
      virtualisation.spiceUSBRedirection.enable = true;
      programs.virt-manager.enable = true;

      # Windows virtio drivers ISO, attach as a CD-ROM during install
      environment.etc."libvirt/virtio-win.iso".source = pkgs.virtio-win.src;
    };

  home.modules.virtualization = {
    # virt-manager can't auto-detect the hypervisor on NixOS, so connect to the system libvirtd by default.
    # This lives in home-manager because COSMIC's dconf profile ignores the NixOS system dconf database.
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
