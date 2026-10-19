{ pkgs, lib, config, ... }:
{
  config = {
    # Initialize Homebrew Casks
    homebrew = {
      enable = true;
      brewPrefix = "/opt/homebrew/bin";
      onActivation = {
        autoUpdate = false;
        cleanup = "none";
        upgrade = false;
      };

      global = {
        brewfile = true;
        lockfiles = true;
      };

      caskArgs.require_sha = true;
    };

    env.HOMEBREW_NO_ANALYTICS = "1";
    env.PATH = [ "/opt/homebrew/bin" ];
  };
}
