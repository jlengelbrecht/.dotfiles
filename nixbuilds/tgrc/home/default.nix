# tgrc/home/default.nix
{ config, pkgs, ... }:
{
  programs = {
    zsh.enable = true;
    git.enable = true;
  };

  # Match your HM release
  home.stateVersion = "25.05";
}
