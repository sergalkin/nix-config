{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    # hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixOS Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    catppuccin,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
    mac-app-util,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;

    # Define user configurations
    users = {
      siv = {
        email = "temp";
        fullName = "change this";
        gitKey = "key";
        name = "ser";
      };
    };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = username: hostname:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
	  mac-app-util.darwinModules.default
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
          nhModules = "${self}/modules/home-manager";
        };
        modules = [
	  (lib.optionals (lib.hasSuffix "darwin" system) mac-app-util.homeManagerModules.default)
          ./home/${username}/${hostname}
          catppuccin.homeManagerModules.catppuccin
        ];
      };
  in {
    darwinConfigurations = {
      "macbook" = mkDarwinConfiguration "siv" "macbook";
    };

    homeConfigurations = {
      "siv@macbook" = mkHomeConfiguration "aarch64-darwin" "siv" "macbook";
      #"siv@desktop" = mkHomeConfiguration "x86_64-linux" "siv" "desktop";
    };

    overlays = import ./overlays {inherit inputs;}; 
  };
}
