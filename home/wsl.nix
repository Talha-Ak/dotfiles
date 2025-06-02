{pkgs, ...}: {
  imports = [
    ./default.nix
  ];

  programs.bash = {
    sessionVariables = {
      PS1 = "\${debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\$ ";
    };
  };

  home.packages = with pkgs; [
  ];
}
