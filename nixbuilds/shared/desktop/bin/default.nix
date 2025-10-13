{ pkgs, ... }:
[
  (import ./change_wallpaper.nix { inherit pkgs; })
  (import ./select_wallpaper.nix { inherit pkgs; })
  (import ./startup.nix { inherit pkgs; })
]
