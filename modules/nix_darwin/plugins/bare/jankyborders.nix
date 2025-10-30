{...}:
{
  homebrew = {
    taps = [
      "FelixKratz/formulae"
    ];
    brews = [
    "borders"
    ];
  };
  services.jankyborders = {
    enable = true;
    hidpi = true;
    style = "round";
    active_color = "0xFFEA6962";
    inactive_color = "0x7C6F6499";
  };
}
