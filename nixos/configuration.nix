{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./laptop.nix
    ./vfio
  ];

  #========== NIX CONFIG ==========

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  #========== BOOT ==========

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
    efi.canTouchEfiVariables = true;
  };

  # Silent boot.
  # boot.initrd.verbose = false;
  # boot.consoleLogLevel = 0;
  # boot.kernelParams = [
  #   "quiet"
  #   "udev.log_level=3"
  # ];

  #========== HARDWARE ==========

  hardware.bluetooth.enable = true;

  # Video acceleration and QSV on Intel
  # https://wiki.nixos.org/wiki/Intel_Graphics
  # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
  # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "nvidia";};
  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.intel-media-driver
      pkgs.vpl-gpu-rt
    ];
  };

  # Enable Wayland support for Chromium/Electron apps
  # https://wiki.archlinux.org/title/PRIME#Some_programs_have_a_delay_when_opening_under_Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  networking.hostName = "caelid";
  networking.networkmanager.enable = true;

  #========== LOCALE ==========

  # Configure keymap
  console.keyMap = "uk";
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
    options = "caps:escape";
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  #========== SERVICES ==========

  # Auto-discover network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.printing = {
    enable = true;
    drivers = [
      pkgs.cups-filters
      pkgs.cups-browsed
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #========== USER ==========

  users.users.talha = {
    isNormalUser = true;
    description = "Talha Abdulkuddus";
    extraGroups = ["networkmanager" "wheel"];
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  # programs.hyprlock.enable = true;

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };

  services.tailscale.enable = true;

  environment.systemPackages = [
    pkgs.kitty
    pkgs.vim
    pkgs.wget
    pkgs.git
    pkgs.wl-clipboard
    pkgs.pciutils
    pkgs.psmisc
  ];

  fonts.packages = [
    pkgs.nerd-fonts.caskaydia-cove
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
