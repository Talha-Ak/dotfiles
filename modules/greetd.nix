{ self, inputs, ... }:
{
  flake.modules.nixos.greetd =
    { pkgs, lib, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks";
            user = "greeter";
          };
        };
      };

      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYHangup = true;
        TTYVTDisallocate = true;
      };
    };
}
