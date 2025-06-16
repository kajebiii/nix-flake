{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    system = "aarch64-darwin";
    configuration = { pkgs, lib, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      ## Configs needed for nix-darwin

      ids.gids.nixbld = 350;

      system.primaryUser = "macstudio-jongbeomkim";
      
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment = {
        systemPackages = [ pkgs.vim ];
        systemPath = [ "/opt/homebrew/bin" ];
        pathsToLink = [ "/Applications" ];
      };
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      security.pam.services.sudo_local.touchIdAuth = true;
      system.defaults = {
        finder = {
          _FXShowPosixPathInTitle = true;  # show full path in finder title
          AppleShowAllExtensions = true;  # show all file extensions
          FXEnableExtensionChangeWarning = false;  # disable warning when changing file extension
          QuitMenuItem = true;  # enable quit menu item
          ShowPathbar = true;  # show path bar
          ShowStatusBar = true;  # show status bar
        };
        dock = {
          autohide = true;
          show-recents = false;  # disable recent apps
          orientation = "right";
          mru-spaces = false;
        };
        menuExtraClock = {
          ShowDate = 1;
          ShowSeconds = true;
        };
      };
    };

    overlays = import ./overlays.nix;
    overlay_module = { config, pkgs, lib, ... }: {
      nixpkgs.overlays = overlays {
        inherit config pkgs nixpkgs-unstable lib;
      };
    };
  in
  {
    # Hostname
    darwinConfigurations."macstudio-jongbeomkim" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        home-manager.darwinModules.home-manager
        configuration
        overlay_module
      ] ++ import ./modules;
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macstudio-jongbeomkim".pkgs;
  };
}
