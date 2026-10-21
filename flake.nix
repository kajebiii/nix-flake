{
  description = "macOS setup: one system, an admin home, and an AI-only home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    # Owns /opt/homebrew and runs `make apply`; never the AI account.
    adminUser = "jongbeom.kim";
    # Flake selector; use `scutil --get LocalHostName` for a machine-specific name.
    configurationName = "macbook-m5-jongbeomkim";

    mkHome = modules: home-manager.lib.homeManagerConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = { inherit inputs; };
    };
  in
  {
    darwinConfigurations.${configurationName} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ({ ... }: {
          ids.gids.nixbld = 350;
          system.primaryUser = adminUser;
          environment.systemPath = [ "/opt/homebrew/bin" ];
          # Leave macOS's /etc/zshrc, /etc/zshenv and /etc/zprofile alone;
          # each user's shell setup comes from Home Manager.
          programs.zsh.enable = false;
          # Set Git commit hash for darwin-version; `make apply` reviews changes since it.
          system.configurationRevision = self.rev or self.dirtyRev or null;
          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 4;
        })
      ] ++ import ./modules/darwin;
    };

    # Each user applies their own home with `make home`, without sudo.
    homeConfigurations = {
      "jongbeom.kim" = mkHome [ ./modules/home/personal ];
      "kajebiii.lab" = mkHome [ ./modules/home/lab ];
    };

    # `make home` runs Home Manager from the locked input.
    packages.${system}.home-manager = home-manager.packages.${system}.default;

    # Expose the package set for convenience.
    darwinPackages = self.darwinConfigurations.${configurationName}.pkgs;
  };
}
