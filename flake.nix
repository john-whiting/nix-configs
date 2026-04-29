{
  description = "JW NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Ghostty
    ghostty.url = "github:ghostty-org/ghostty";
    ragenix.url = "github:yaxitech/ragenix";
    nixvim-config.url = "path:./nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
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
          specialArgs = { inherit inputs outputs; };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix
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
          extraSpecialArgs = { inherit inputs outputs unstable; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/john.nix ];
        };
        "john@kv" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs unstable; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/john-kv.nix ];
        };
      };
    };
}
