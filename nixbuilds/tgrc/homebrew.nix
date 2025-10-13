{ ... }:
{
  nix-homebrew = {
    enable        = true;
    enableRosetta = true;
    user          = "jlengelbrecht96";  # <-- same macOS user
    autoMigrate   = true;
  };
}
