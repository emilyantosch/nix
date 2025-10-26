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
    active_color = "0xFFFFFFFF";
  };
}
