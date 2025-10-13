{ lib, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    # Add your own hosts here when you're ready.
    matchBlocks = {
      "my-host" = {
        hostname = "example.com";
        user = "devbox";
        port = 22;
        # identityFile = "~/.ssh/id_ed25519";  # uncomment and set if you want a specific key
      };

      # Keep GitHub handy; adjust or remove as you like.
      "github.com" = {
        user = "git";
        forwardAgent = true;
        # identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
