{ inputs, ... }:
{
  imports = [
    inputs.sherlock.homeManagerModules.default
  ];

  programs.sherlock = {
    enable = true;
    settings = {
      aliases = {
        vesktop = {
          name = "Discord";
        };
      };
      config = {
        debug = {
          try_suppress_warnings = true;
        };
      };
      ignore = ''
        Avahi*
      '';
      launchers = [
        {
          name = "App Launcher";
          type = "app_launcher";
          args = { };
          priority = 1;
          home = true;
        }
        {
          name = "Pomodoro Timer";
          type = "pomodoro";
          priority = 0;
          home = true;
          spawn_focus = false;
        }
      ];
      style = null;
    };
  };
}
