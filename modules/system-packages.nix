{ self, inputs, ... }:
{
  flake.modules.nixos.system-packages =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        pkgs.kitty
        pkgs.vim
        pkgs.wget
        pkgs.wl-clipboard
        pkgs.pciutils
        pkgs.psmisc
      ];
    };
}
