{ self, inputs, ... }:
{
  flake.modules.homeManager.gtk =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin.gtk.icon.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = "catppuccin-mocha-blue-standard";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "blue" ];
            size = "standard";
            variant = "mocha";
          };
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
}
