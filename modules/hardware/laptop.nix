{ self, inputs, ... }:
{
  flake.modules.nixos.laptop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      boot.kernelParams = [ "i915.enable_dpcd_backlight=1" ];

      services = {
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

        thermald.enable = true;

        libinput.enable = true;
      };
    };
}
