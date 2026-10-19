{ lib, config, options, inputs, ... }:
let
  user = config.system.primaryUser;
in with lib; {
  options = with types; {
    home = {
      file = mkOption {
        type = attrs;
        default = {};
        description = "Files to place directly in $HOME";
      };

      configFile = mkOption {
        type = attrs;
        default = {};
        description = "Config files to place in $HOME/.config";
      };

      services = mkOption {
        type = attrs;
        default = {};
        description = "Home-manager provided user services";
      };

      packages = mkOption {
        type = listOf package;
        default = [];
        description = "Home-manager provided packages";
      };

      programs = mkOption {
        type = attrs;
        default = {};
        description = "Home-manager provided programs";
      };
    };
  };
  
  config = {
    # Use macOS zsh instead of installing another shell and its completions.
    programs.zsh.enable = false;
    users.users.${user} = {
      name = user;
      home = "/Users/${user}";
      shell = "/bin/zsh";
    };

    # Keep Nix/Homebrew paths available to the system shell without plugins.
    home.file.".zshenv".text = ''
      if [ -z "''${__NIX_DARWIN_SET_ENVIRONMENT_DONE-}" ]; then
        . ${config.system.build.setEnvironment}
      fi
    '';
    home.file.".zprofile".text = ''
      # Restore Nix paths after macOS /etc/zprofile runs path_helper.
      . ${config.system.build.setEnvironment}
    '';

    # Initialize Home
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };

      users.${user} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          packages = mkAliasDefinitions options.home.packages;
          stateVersion = "23.11";
        };
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
        };
      };
    };
  };
}
