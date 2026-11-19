{ inputs, ... }:
let
  # Region names are PIA's .ovpn file names without the extension (e.g. "us_chicago").
  # Set to null to create a profile for every region PIA publishes.
  piaRegions = [
    "us_chicago"
    "us_east"
    "us_west"
    "us_texas"
  ];

  # Encrypted env file with PIA_USERNAME=... and PIA_PASSWORD=... lines.
  # PIA profiles are only created once this file exists in the secrets repo.
  piaCredentials = "${inputs.john-nvim-secrets}/pia-credentials.env.age";
in
{
  nixos.modules.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # PIA's official OpenVPN bundle. The URL is unversioned, so when PIA changes it the
      # hash mismatches and this must be updated with: nix-prefetch-url --unpack <url>
      piaBundle = pkgs.fetchzip {
        url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
        hash = "sha256-mhXV2CF8G7dAkXY9KI7g2qSOlxUzyqgJlidL1At46GU=";
        stripRoot = false;
      };

      # Read at eval time (import-from-derivation) so the region list follows PIA's bundle.
      allRegions =
        builtins.readDir piaBundle
        |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".ovpn" name)
        |> lib.mapAttrs' (
          name: _: lib.nameValuePair (lib.removeSuffix ".ovpn" name) (builtins.readFile "${piaBundle}/${name}")
        );

      regions =
        if piaRegions == null then
          allRegions
        else
          lib.genAttrs piaRegions (
            region: allRegions.${region} or (throw "PIA region '${region}' not found in the OpenVPN bundle")
          );

      # Every PIA config embeds the same CA, so any region's copy works.
      caCert =
        let
          ovpn = lib.head (lib.attrValues allRegions);
          match = builtins.match ".*<ca>\n(.*)</ca>.*" ovpn;
        in
        pkgs.writeText "pia-ca.crt" (lib.head match);

      remoteOf =
        ovpn:
        let
          line = lib.findFirst (lib.hasPrefix "remote ") (throw "PIA config has no remote line") (
            lib.splitString "\n" ovpn
          );
          parts = lib.splitString " " line;
        in
        "${lib.elemAt parts 1}:${lib.elemAt parts 2}";

      # NetworkManager needs a UUID; derive a stable one from the region name.
      uuidOf =
        region:
        let
          h = builtins.hashString "sha256" "pia-${region}";
        in
        "${lib.substring 0 8 h}-${lib.substring 8 4 h}-${lib.substring 12 4 h}-${lib.substring 16 4 h}-${lib.substring 20 12 h}";

      mkProfile = region: ovpn: {
        connection = {
          id = "PIA ${region}";
          uuid = uuidOf region;
          type = "vpn";
          autoconnect = false;
        };
        vpn = {
          service-type = "org.freedesktop.NetworkManager.openvpn";
          connection-type = "password";
          remote = remoteOf ovpn;
          ca = "${caCert}";
          cipher = "AES-128-CBC";
          auth = "SHA1";
          compress = "yes";
          remote-cert-tls = "server";
          reneg-seconds = "0";
          username = "$PIA_USERNAME";
          password-flags = "0";
        };
        vpn-secrets.password = "$PIA_PASSWORD";
        ipv4.method = "auto";
        # PIA's OpenVPN servers don't carry IPv6.
        ipv6.method = "ignore";
      };
    in
    # mkMerge, not `//`: a shallow `//` would let the second block's `networking` replace the first's.
    lib.mkMerge [
      {
        networking.networkmanager.plugins = [
          pkgs.networkmanager-openvpn
        ];
      }
      (lib.mkIf (builtins.pathExists piaCredentials) {
        age.secrets.pia-credentials.file = piaCredentials;

        networking.networkmanager.ensureProfiles = {
          environmentFiles = [ config.age.secrets.pia-credentials.path ];
          profiles = lib.mapAttrs' (region: ovpn: lib.nameValuePair "pia-${region}" (mkProfile region ovpn)) regions;
        };
      })
    ];
}
