{ self, inputs, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, lib, ... }:
    {
      home.shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -lh --color=auto";
        la = "ls -lAh --color=auto";
        nfu = "nix flake update --flake ~/nix";
        hrb = "nh home switch";
        srb = "nh os switch";
      };

      home.packages = with pkgs; [
        vim
        curl
        wget
        btop
      ];

      programs.bash = {
        enable = true;
        historyControl = [ "ignoredups" ];
      };
    };
}
