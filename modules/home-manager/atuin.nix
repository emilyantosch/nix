{
  pkgs,
  ...
}:
{
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      auto_sync = true;
      update_check = false;
      style = "full";
      daemon = {
        enabled = true;
        autostart = true;
      };
      threads.capture = true;
    };
  };
}
