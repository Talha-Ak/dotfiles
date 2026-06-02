# Taken from https://github.com/NixOS/nixos-hardware
{
  config,
  lib,
  ...
}: {
  # Use DPCD protocol instead of default PWM.
  boot.kernelParams = ["i915.enable_dpcd_backlight=1"];
  services = {
    # Power Management.
    # PPD and TLP clash when enabled simultaneously.
    # https://github.com/NixOS/nixos-hardware/issues/260
    tlp = {
      enable = lib.mkDefault (
        (lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
        || !config.services.power-profiles-daemon.enable
      );
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };

    # Manage Intel CPU thermals.
    thermald.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
}
