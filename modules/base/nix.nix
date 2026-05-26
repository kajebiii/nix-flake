{ pkgs, lib, config, ... }:
{
  config = {
    nix.settings = {
      experimental-features = "nix-command flakes";
      access-tokens =
        let
          token = builtins.getEnv "GITHUB_TOKEN";
        in
        if token != "" then [ "github.com=${token}" ] else [ ];
    };
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
