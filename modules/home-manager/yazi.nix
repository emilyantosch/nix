{ ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        edit = {
          run = "$EDITOR %s";
          block = true;
        };
      };
      theme = {
        flavor = {
          dark = "gruvbox-dark";
        };
      };
    };
  };
}
