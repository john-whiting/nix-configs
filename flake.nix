{
  description = "JW NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Ghostty
    ghostty.url = "github:ghostty-org/ghostty";

    ragenix.url = "github:yaxitech/ragenix";
    secrets.url = "git+ssh://git@github.jwhiting.dev/john-whiting/nix-secrets.git";

    nixvim-config.url = "path:./nixvim";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim-config.inputs.secrets.follows = "secrets";

    winapps.url = "github:winapps-org/winapps";
    winapps.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ragenix,
      secrets,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true; # If needed
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild switch --flake .#lt14s'
      nixosConfigurations = {
        lt14s = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix
            ragenix.nixosModules.default
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through one of the following:
      # - 'home-manager switch --flake .#john@personal'
      # - 'home-manager switch --flake .#john@kv'
      homeConfigurations = {
        "john@personal" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              unstable
              secrets
              ;
          };
          # > Our main home-manager configuration file <
          modules = [
            ragenix.homeManagerModules.default
            ./home-manager/john.nix
          ];
        };
        "john@kv" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              unstable
              secrets
              ;
          };
          # > Our main home-manager configuration file <
          modules = [
            ragenix.homeManagerModules.default
            ./home-manager/john-kv.nix
          ];
        };
      };
    };
}
