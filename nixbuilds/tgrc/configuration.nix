# tgrc/configuration.nix
{ config, lib, pkgs, ... }:
{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim ansible terraform terraform-docs obsidian drawio vault git
    awscli2 azure-cli bash-completion bottom curl jq gnumake vscode
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # Optional Homebrew payload; the module import is done in the flake above.
  homebrew = {
    enable = true;
    brews  = [ "podman-compose" "thefuck" ];
    casks  = [
      "amethyst" "azure-data-studio" "clipy" "font-fira-code"
      "font-hack-nerd-font" "iterm2" "postman" "powershell"
      "warp" "wireshark" "podman-desktop"
    ];
    onActivation = { cleanup = "zap"; autoUpdate = true; upgrade = true; };
  };

  # Alias Nix GUI apps into /Applications/Nix Apps
  system.activationScripts.applications.text =
    let env = pkgs.buildEnv {
      name = "system-apps";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    }; in lib.mkForce ''
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
      "/System/Applications/Launchpad.app"
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
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle     = "Dark";
      KeyRepeat               = 2;
    };
  };

  system.stateVersion = 5;
}
