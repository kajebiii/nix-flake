{ pkgs, lib, config, ... }:
{
  config = {
    nix.settings = {
      experimental-features = "nix-command flakes";
    };
    # Authentication is read at runtime from the user's Nix configuration.
    # Never put tokens in Nix expressions: generated files enter the Nix store.
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
