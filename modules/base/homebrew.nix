{ pkgs, lib, config, ... }:
{
  config = {
    # Initialize Homebrew Casks
    homebrew = {
      enable = true;
      prefix = "/opt/homebrew";
      onActivation = {
        autoUpdate = false;
        cleanup = "none";
        upgrade = false;
      };

      global = {
        brewfile = true;
      };

      caskArgs.require_sha = true;
    };

    env.HOMEBREW_NO_ANALYTICS = "1";
    env.PATH = [ "/opt/homebrew/bin" ];
  };
}
