# flake.nix
{
  description = "Fadora Laptop centralized Nix and Home Manager configuration";

  # Inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Outputs
  outputs = { self, nixpkgs, home-manager, ... }: {
    # Home Manager configuration for your user
    homeConfigurations."devbox" = home-manager.lib.homeManagerConfiguration {
      inherit nixpkgs;
      configuration = ./home.nix;
    };
  };
}
