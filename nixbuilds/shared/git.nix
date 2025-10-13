{ lib, config, ... }:

{
  programs.git = {
    enable = true;

    # Default (personal) identity
    userName  = "jlengelbrecht";
    userEmail = "jlengelbrecht96@gmail.com";

    # Nice quality-of-life defaults
    extraConfig = {
      branch.autoSetupMerge  = "simple";
      branch.autoSetupRebase = "always";
      push.autoSetupRemote   = true;
      push.default           = "current";
    };

    # Auto-switch identity for any repo under ~/gitlab/
    includes = [
      {
        condition = "gitdir:~/gitlab/";
        contents.user = {
          name  = "jlengelbrecht (GitLab)";
          email = "jlengelbrecht96@homelab0.org"; # <-- put your GitLab email here
        };
      }
    ];
  };
}
