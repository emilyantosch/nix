# Agent skills shared by every coding agent, vendored from the `skills` CLI
# (`npx skills`) install that used to live unmanaged in ~/.agents/skills.
# Upstream: github.com/mattpocock/skills, plus gpt-taste from
# github.com/Leonxlnx/taste-skill. Update by editing the folders in ./skills.
#
# Every folder in ./skills is linked to ~/.agents/skills/<name>, which pi (and
# Codex) read natively, and registered as a Claude Code skill. The
# ~/.agents/skills directory itself stays writable, so unmanaged skills can
# still be installed next to these.
{ lib, ... }:
let
  skills = lib.mapAttrs (name: _: ./skills + "/${name}") (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./skills)
  );
in
{
  home.file = lib.mapAttrs' (
    name: path: lib.nameValuePair ".agents/skills/${name}" { source = path; }
  ) skills;

  programs.claude-code.skills = skills;
}
