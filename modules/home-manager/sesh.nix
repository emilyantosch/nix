{ ... }:
let
  athena = "athena";
in
{
  programs.sesh = {
    enable = true;
    settings = {
      default_session = {
        startup_command = athena;
      };
      session = [
      ];
      wildcard = [
        {
          pattern = "~/projects/projects/*";
          startup_command = athena;
        }
      ];
    };
  };
}
