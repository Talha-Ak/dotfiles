{pkgs, ...}: {
  imports = [
    ./nvim
  ];

  home = {
    username = "talha";
    homeDirectory = "/home/talha";

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lh --color=auto";
      la = "ls -lAh --color=auto";
      nfu = "nix flake update --flake ~/nix";
      hrb = "home-manager switch --flake ~/nix";
    };

    packages = with pkgs; [
      git
      vim
      curl
      wget
      btop
    ];
  };

  programs.bash = {
    enable = true;
    historyControl = ["ignoredups"];
  };

  programs.git = {
    enable = true;
    userName = "Talha Abdulkuddus";
    userEmail = "git@talhaak.com";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
