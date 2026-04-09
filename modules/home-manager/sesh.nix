{ ... }:
{
  programs.sesh = {
    enable = true;
    settings = {
      session = [
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
