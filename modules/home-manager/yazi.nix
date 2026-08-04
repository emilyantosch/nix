{ ... }:
{
  programs.yazi = {
    shellWrapperName = "y";
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
