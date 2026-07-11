{ ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    settings = {
      theme = {
        flavor = {
          dark = "gruvbox-dark";
        };
      };
    };
  };
}
