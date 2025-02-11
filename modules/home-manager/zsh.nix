{pkgs, ...}:
{
  programs.zsh = {
      enable = true;
      history = {
        size = 5000;
        append = true;
        share = true;
        ignoreAllDups = true;
        ignoreDups = true;
        path = "$HOME/.zsh_history;";
      };

      initExtra = 
      ''
        alias v nvim
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-backward

        eval "$(fzf --zsh)"
        eval "$(zoxide init zsh)"
      '';
      
        zplug = {
          enable = true;
          plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
    };
  };
}

# 13810
# *
# a2
#
# Geräte: Freigabedatum
# Das Freigabedatum bei Geräten ist das tatsächliche richtige Datum
#
# Ab wann sind die an YKI übergeben
# Rohre: CheckmateDatum oder Änderungsdatum
# 
# Durchführungen: 
# Bei Freigabedatum ist bei Durchführungen ist das tatsächlich richtige Datum
# 
# Revisonen rausfiltern und nach Durchführung statt Durchführungen fragen bei IT
