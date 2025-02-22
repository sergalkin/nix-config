{
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ../programs/zoxide
    ../programs/alacritty
    ../programs/atuin
    ../programs/bat
    ../programs/btop
    ../programs/fastfetch
    ../programs/fzf
    ../programs/git
    ../programs/go
    ../programs/gpg
    ../programs/lazygit
    ../programs/neovim
    ../programs/starship
    ../programs/telegram
    ../programs/tmux
    ../programs/zsh
    ../programs/htop
    ../programs/eza
    ../programs/spicetify
    ../programs/aerospace
    ../scripts
  ];


  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
  };

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages = with pkgs;
    [
      karabiner-elements
      vscode
      obsidian
      alacritty
      postman
      lens
      qbittorrent
      wrk
      docker
      docker-compose
      go-migrate
      golangci-lint
      zsh-autosuggestions
      yq-go
      wget
      dig
      du-dust
      fd
      jq
      fira-code
      monaspace
      kubectl
      lazydocker
      nh
      openconnect
      ripgrep
      zsh-syntax-highlighting
      inetutils
      glances
      tree
    ]
    ++ lib.optionals stdenv.isDarwin [
      iina
      aerospace
      #raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      insomnia
      hiddify-app
      unzip
      wl-clipboard
    ];

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
