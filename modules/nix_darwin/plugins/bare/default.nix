{ lib, ... }:
{
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".kbd" "${fn}" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
