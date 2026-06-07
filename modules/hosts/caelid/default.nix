{ self, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.caelid = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with self.modules.nixos;
      [
        nvidia-optimus
        laptop
        boot
        nix-settings
        networking
        locale
        bluetooth
        graphics
        docker
        power
        printing
        pipewire
        tailscale
        flatpak
        greetd
        steam
        adb
        system-packages
        fonts
        nix-ld
        talha
        hyprland
      ]
      ++ [
        ./_hardware.nix
        { system.stateVersion = "24.11"; }
        { networking.hostName = "caelid"; }
      ];
  };

  flake.homeConfigurations."talha@caelid" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = with self.modules.homeManager; [
      talha
      shell
      git
      direnv
      yazi
      nvim
      gtk
      desktop-apps
      hyprland
    ];
  };
}
