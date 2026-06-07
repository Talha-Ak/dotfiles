{ self, inputs, ... }:
{
  flake.modules.homeManager.wsl =
    { pkgs, lib, ... }:
    {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 2";
        flake = "~/nix";
      };

      programs.bash = {
        sessionVariables = {
          PS1 = "\${debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\$ ";
        };
        initExtra = ''
          if command -v npiperelay.exe &>/dev/null; then
              export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

              if ! ss -a | grep -q $SSH_AUTH_SOCK; then
                  rm -f $SSH_AUTH_SOCK

                  (setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
              fi
          fi
        '';
      };

      home.packages = with pkgs; [
        socat
      ];
    };
}
