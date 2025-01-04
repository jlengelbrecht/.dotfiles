{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = [
        pkgs.neovim
        pkgs.ansible
        pkgs.terraform
        pkgs.terraform-docs
        pkgs.obsidian
        pkgs.drawio
        pkgs.vault
        pkgs.git
        pkgs.awscli
        pkgs.azure-cli
        pkgs.bash-completion
        pkgs.bottom
        pkgs.curl
        pkgs.jq
        pkgs.gnumake
        pkgs.vscode
      ];

      homebrew = {
        enable = true;
        casks = [
          "amethyst"
          "atom"
          "azure-data-studio"
          "clipy"
          "font-fira-code"
          "font-hack-nerd-font"
          "iterm2"
          "podman-desktop"
          "postman"
          "powershell"
          "warp"
          "wireshark"
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
      
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

     system.activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
      pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
      '';
      
      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/Applications/Microsoft Teams.app"
          "/Applications/Microsoft Outlook.app"
          "/Applications/Google Chrome.app"
          "/Applications/Citrix Secure Access.app"
          "/Applications/Self Service.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Warp.app"
        ];
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };

      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."work-mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "jlengelbrecht96";
            autoMigrate = true;
          };
        }
      ];
    };
    darwinPackages = self.darwinConfigurations."work-mac".pkgs;
  };
}
