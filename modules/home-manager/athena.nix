{ pkgs, ... }:
let
  # athena is the neovim config living under ~/.config/athena. EDITOR has to be
  # a single executable (git, sudoedit, etc. don't expand env prefixes), so wrap
  # the NVIM_APPNAME switch in a script instead of using an alias.
  athena = pkgs.writeShellScriptBin "athena" ''
    NVIM_APPNAME=athena exec nvim "$@"
  '';
in
{
  home.packages = [ athena ];

  home.sessionVariables = {
    EDITOR = "athena";
    VISUAL = "athena";
  };
}
