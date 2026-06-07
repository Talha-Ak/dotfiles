{ self, inputs, ... }:
{
  flake.modules.nixos.locale =
    { pkgs, lib, ... }:
    {
      console.keyMap = "uk";
      services.xserver.enable = false;
      services.xserver.xkb = {
        layout = "gb";
        variant = "";
        options = "caps:escape";
      };

      time.timeZone = lib.mkDefault "Europe/London";

      i18n.defaultLocale = "en_GB.UTF-8";
    };
}
