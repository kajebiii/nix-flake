{ pkgs, lib, config, ... }:
{
  config = {
    # Initialize Homebrew Casks
    homebrew = {
      enable = true;
      prefix = "/opt/homebrew";
      onActivation = {
        # Refresh the index and upgrade casks on every apply so AI CLIs stay current.
        autoUpdate = true;
        cleanup = "none";
        upgrade = true;
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
