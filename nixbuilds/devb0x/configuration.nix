{ pkgs, ... }:
{
  # CONFIGURATION FOR A AMD BASED DEV SYSTEM FEATURING
  # Motherboard: ROG Zenith Extreme Alpha 2
  # CPU: AMD Ryzen Threadripper 3970X
  # GPU: AMD Radeon RX 7900 XTX
  # RAM: 128G
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared/desktop/dev/docker/default.nix
    # ../shared/sops.nix
    ../shared/optimise.nix
    ../shared/security.nix
  ];

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      busybox
      git
      vim
    ];

    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # fonts:
  fonts.packages = with pkgs; [ nerd-fonts.hack ];

  # Bootloader.
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    # loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.enable = true;
    loader.grub.devices = [ "nodev" ];
    loader.grub.efiSupport = true;
    loader.grub.useOSProber = true;
    initrd.kernelModules = [ "amdgpu" ];
  };

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
      wacom.enable = true;

      xkb.layout = "us";
      xkb.variant = "";
    };

    dbus.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    ollama = {
      enable = true;
      acceleration = "rocm";
      package = pkgs.ollama;
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      };
    };
    # open-webui.enable = true;

    # Enable automatic login for the user.
    # getty.autologinUser = "devbox";
  };

  # Configure console keymap
  console.keyMap = "us";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    graphics.extraPackages = with pkgs; [
      amdvlk
    ];
    # For 32 bit applications
    graphics.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";

  programs = {
    zsh.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  services.openssh.enable = true;

  networking = {
    hostName = "devb0x"; # Define your hostname.
    interfaces."enp70s0".wakeOnLan.enable = true;
    # Enable networking
    networkmanager.enable = true;
  };
}
