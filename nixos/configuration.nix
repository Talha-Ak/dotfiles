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

  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Periodically run the nix store optimiser.
  nix.optimise.automatic = true;

  # Perodically run the nix garbage collector.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
    efi.canTouchEfiVariables = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;

    # Video acceleration on Intel
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

  networking.hostName = "caelid";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Wayland support for Chromium/Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # SSD Trim.
  services.fstrim.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
    options = "caps:escape";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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

  programs.steam.enable = true;
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
    nerd-fonts.jetbrains-mono
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
