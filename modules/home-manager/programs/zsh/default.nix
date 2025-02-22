{pkgs, ...}: {
  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker-compose" "zoxide" "laravel" "postgres" "sublime" "brew" "composer" "copybuffer" "npm" "z"];
    };
    shellAliases = {
      ff = "fastfetch";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";

      ld = "lazydocker";
      lg = "lazygit";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
    };
    initExtra = ''
      HISTSIZE=5000
      HISTFILE=~/.zsh_history
      HISTDUP=erase
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups
 
      zstyle ':omz:update' mode auto
     
      # alias
      alias p74="brew unlink php && brew link --overwrite --force php@7.4 && php -v"
      alias p81="brew unlink php && brew link --overwrite --force php@8.1 && php -v"
      alias p82="brew unlink php && brew link --overwrite --force php@8.2 && php -v"
      alias p83="brew unlink php && brew link --overwrite --force php@8.3 && php -v"
      alias p84="brew unlink php && brew link --overwrite --force php@8.4 && php -v"

      # bindings
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
     
      source <(fzf --zsh)
    '';
  };
}
