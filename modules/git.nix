{ self, inputs, ... }:
{
  flake.modules.homeManager.git =
    { pkgs, lib, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user.name = "Talha Abdulkuddus";
          user.email = "git@talhaak.com";
        };
      };
    };
}
