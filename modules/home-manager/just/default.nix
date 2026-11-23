# The global justfile, for recipes that are the same in every project: run one
# from inside a project as `just -g <recipe>`, list them with `just -g --list`.
# just reads ~/.config/just/justfile on Linux and macOS alike.
#
# ./config is linked to ~/.config/just as a whole, so a recipe's helper files
# sit in a folder of their own beside the justfile (./config/loop for
# `just -g loop`) and the recipe finds them by source_directory().
{ ... }:
{
  xdg.configFile."just".source = ./config;
}
