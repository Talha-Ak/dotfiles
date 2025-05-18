# Taken from https://github.com/NixOS/nixos-hardware
{
  config,
  lib,
  ...
}: {
  services = {
    # Power Management.
    # Gnome 40 introduced a new way of managing power, without tlp.
    # However, these 2 services clash when enabled simultaneously.
    # https://github.com/NixOS/nixos-hardware/issues/260
    tlp.enable =
      lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
        || !config.services.power-profiles-daemon.enable);

    # Manage Intel CPU thermals.
    thermald.enable = true;
  };
}
