{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./laptop.nix
    ./vfio
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

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

  hardware.bluetooth.enable = true;

  # Video acceleration and QSV on Intel
  # https://wiki.nixos.org/wiki/Intel_Graphics
  # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  networking.hostName = "caelid";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Wayland support for Chromium/Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Configure keymap
  console.keyMap = "uk";
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
    options = "caps:escape";
  };

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.talha = {
    isNormalUser = true;
    description = "Talha Abdulkuddus";
    extraGroups = ["networkmanager" "wheel"];
  };

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    wl-clipboard
    pciutils
    psmisc
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
