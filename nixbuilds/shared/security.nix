{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;

    users.devbox = {
      home = "/home/devbox/";
      isNormalUser = true;
      description = "devbox";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "uinput"
      ];
      # hashedPasswordFile = "/run/secrets/HASHED_PASSWORD"; # Uncomment if you manage password via sops/secret
      openssh.authorizedKeys.keys = [
        # NOTE: This is an YubiKey ssh key
        ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3HBGb+TFCsn0k6D1w55avuWxm634UlhAibFhG/VzqhqF/2hgut8Hy+fPc1Org7PR0qszwGX1DfxcRXi3u0qcblEvjhOg7QQ/yfHGCq8+PyuunRhbomOpOLDihdOhT1k78sSJ1A1OdCCGpKkhqhzo2jdf6Pr4DEYxzMYp75bj7dZZv2kJ9Z6wfqoOV4liWZvNGIIlQe5R/qajzRJZDVUatOCvwyTudQgPIzEfbRTW1XnVhVRKsvN0MwzQb/qAh2eim6EjWLp8n/UR8b96Eer6U4a8B0M5CTCF9TW7EBkVGJZc1BpEj95o2Dq2IzXoY4bAIxaAXZq21Gm7UWMtZexnF PIV AUTH pubkey''
      ];
    };
  };

  security = {
    rtkit.enable = true;

    # Passwordless sudo for devbox (convenient but powerful)
    sudo = {
      enable = true;
      extraConfig = ''
        devbox ALL=(ALL) NOPASSWD: ALL
      '';
    };

    polkit.enable = true;
  };

  # YubiKey tooling available at runtime (ykpers, ykpersonalize, ykpamcfg, etc.)
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false; # set true only if you plan to use GPG agent for SSH
  };

  programs.ssh.startAgent = true;

  # PAM knobs: keep everything password-only for first boot
  security.pam.services = {
    swaylock.u2fAuth    = false; # set to true after enrolling U2F
    swaylock.yubicoAuth = false; # set to true after enrolling Yubico CR
    swaylock.unixAuth   = true;  # you can switch this off AFTER verifying key auth works
    login.u2fAuth       = false; # set to true after enrolling U2F
    # sudo.u2fAuth      = false; # set to true later if you want U2F-gated sudo
  };

  # Smartcard daemon (needed for PIV/OpenPGP; not needed for pure FIDO2/U2F)
  # services.pcscd.enable = true;

  # Don’t enable the Yubico PAM module until you’ve initialized it
  security.pam.yubico = {
    enable  = false;             # flip to true later
    control = "sufficient";
    debug   = true;              # helpful during first enable; set false later
    mode    = "challenge-response";
    # id = [ "25802329" "25440300" ];
    # ^ Only needed if you decide to use YubiCloud OTP mode (not used for CR/U2F).
  };

  programs.yubikey-touch-detector = {
    enable     = true;
    unixSocket = true;
    libnotify  = true;
    verbose    = false;
  };
}
