{
  pkgs,
  config,
  outputs,
  userConfig,
  ...
}: {
  environment.systemPackages = with pkgs; [
    neofetch
    alacritty
    mkalias
    obsidian
    karabiner-elements
    vscode
    aerospace
    iterm2
  ];

  # Add nix-homebrew configuration
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${userConfig.name}";
  };

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false;
    };
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System settings
  system = {
    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleICUForce24HourTime = true;
        KeyRepeat = 2;
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        NSDocumentSaveNewDocumentsToCloud = true;
        "com.apple.keyboard.fnState" = true;
      };
      LaunchServices = {
        LSQuarantine = false;
      };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        NewWindowTarget = "Home";
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        ShowHardDrivesOnDesktop = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      dock = {
        autohide = true;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        enable-spring-load-actions-on-all-items = true;
        mouse-over-hilite-stack = true;
        mineffect = "genie";
        orientation = "bottom";
        tilesize = 30;
        magnification = true;
        show-process-indicators = false;
        largesize = 50;
        persistent-apps = [
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Mail.app"
        ];
        persistent-others = [];
      };
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/temp";
        type = "png";
        disable-shadow = true;
      };
      magicmouse = {
        MouseButtonMode = "TwoButton";
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
        ShowSeconds = false;
      };
    };
  };

  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    roboto
  ];

  homebrew = {
    enable = true;
    taps = [
      "shivammathur/php"
    ];
    brews = [
      # git нужно будет переставить потом через home TODO
      "git" 
      "mas"
      "glances"
      "composer"
      "go"
      "golang-migrate"
      "golangci-lint"
      "wrk"
      "shivammathur/php/php@7.4"
      "php@8.1"
      "php@8.2"
      "php@8.3"
      "php@8.4"
    ];
    casks = [
      "iina"
      "font-fira-code"
      "font-monaspace"
      "leader-key"
      #"raycast"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
}
