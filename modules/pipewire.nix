{ self, inputs, ... }:
{
  flake.modules.nixos.pipewire =
    { pkgs, lib, ... }:
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
