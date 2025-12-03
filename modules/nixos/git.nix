{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = null;
    config = {
      url = {
        "ssh://git@github.com/" = {
          insteadOf = [
          "https://github.com/"
          ];
        };
      };
    };
    lfs = {
      enable = true;

    };
  };
}
