{
  config,
  pkgs,
  inputs,
  secrets,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = [
    inputs.winapps.packages.${system}.winapps
    inputs.winapps.packages.${system}.winapps-launcher
  ]
  ++ (with pkgs; [
    freerdp
    dialog
    libnotify
    netcat-openbsd
  ]);

  age.secrets.winapps-conf.file = "${secrets}/app-winapps-conf.age";

  systemd.user.services.winapps-conf-link = {
    Unit = {
      Description = "Symlink winapps.conf to its decrypted agenix secret";
      After = [ "agenix.service" ];
      Wants = [ "agenix.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.coreutils}/bin/mkdir -p %h/.config/winapps"
        "${pkgs.coreutils}/bin/ln -sfT ${config.age.secrets.winapps-conf.path} %h/.config/winapps/winapps.conf"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
