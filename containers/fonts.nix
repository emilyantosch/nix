{pkgs, ...}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only # symbols icon only
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    roboto
    source-sans
    font-awesome
    material-design-icons
  ];
}
