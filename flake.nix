{
  description = "Dedicated AI development environment for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    # macOS account name: id -un
    username = "jongbeom.kim";
    # Flake selector; use `scutil --get LocalHostName` for a machine-specific name.
    configurationName = "macbook-m5-jongbeomkim";
    configuration = { ... }: {
      ## Configs needed for nix-darwin

      ids.gids.nixbld = 350;

      system.primaryUser = username;

      environment = {
        systemPath = [ "/opt/homebrew/bin" ];
      };
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    };
  in
  {
    darwinConfigurations.${configurationName} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.darwinModules.home-manager
        configuration
      ] ++ import ./modules;
    };

    # Expose the package set for convenience.
    darwinPackages = self.darwinConfigurations.${configurationName}.pkgs;
  };
}
