{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    justnixvim.url = "github:JustAlternate/justnixvim";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ADD THIS if you plan to manage Homebrew declaratively on macOS
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable-nixpkgs, home-manager, sops-nix, nix-darwin, nix-homebrew, ... }@inputs:
  let
    system    = "x86_64-linux";
    systemMac = "aarch64-darwin";
    systemArm = "aarch64-linux";

    nixos-overlays = [
      (_: prev: {
        unstable = import unstable-nixpkgs {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })
    ];
  in
  {
    nixosConfigurations = {
      devb0xNixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./devb0x/configuration.nix
          home-manager.nixosModules.home-manager
          # sops-nix.nixosModules.sops  # keep commented until you wire secrets
          { nixpkgs.overlays = nixos-overlays; }
          {
            home-manager = {
              useGlobalPkgs   = true;
              useUserPackages = true;
              users.devbox    = import ./devb0x/home;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };

    darwinConfigurations."tgrc" = nix-darwin.lib.darwinSystem {
      system = systemMac;
      specialArgs = { inherit inputs self; };
      modules = [
        home-manager.darwinModules.home-manager
        ./tgrc/configuration.nix
        ./tgrc/homebrew.nix
        { nixpkgs.overlays = nixos-overlays; }

        # IMPORT THE nix-homebrew MODULE so homebrew.* options are available
        inputs.nix-homebrew.darwinModules.nix-homebrew

        {
          home-manager = {
            useGlobalPkgs   = true;
            useUserPackages = true;
            users.jlengelbrecht96 = import ./tgrc/home;  # ⬅️ set your mac short username here
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}
