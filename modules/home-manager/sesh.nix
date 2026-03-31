{ ... }:
{
  programs.sesh = {
    enable = true;
    settings = {
      session = [
        {
          name = "nix config";
          pattern = "~/.config/nix/";
        }
      ];
      wildcard = [
        {
          pattern = "~/projects/projects/*";
          startup_command = "vi";
        }
      ];
    };
  };
}
