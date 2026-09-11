# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-experimental-features = [ "pipe-operators" ];
  };

  inputs = {
    files = {
      url = "github:mightyiam/files";
      flake = false;
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    import-tree.url = "github:vic/import-tree";
    john-nvim-secrets.url = "git+ssh://git@github.jwhiting.dev/john-whiting/nix-secrets.git";
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixvim.url = "github:nix-community/nixvim";
    ragenix.url = "github:yaxitech/ragenix";
  };
}
