{ ... }:
{
  config = {
    homebrew = {
      enable = true;
      prefix = "/opt/homebrew";
      onActivation = {
        # Refresh the index and upgrade casks on every apply so AI CLIs stay current.
        autoUpdate = true;
        cleanup = "none";
        upgrade = true;
      };
      global.brewfile = true;
      caskArgs.require_sha = true;

      # Orca is distributed through its maintainer's tap, not homebrew-cask.
      taps = [ "stablyai/orca" ];
      # GitHub CLI; Orca uses it for issues, PRs, and checks.
      brews = [ "gh" ];
      casks = [
        # Native command-line tools; reuse the existing terminal and editor.
        "codex"
        # Latest channel; the plain cask follows the slower stable channel.
        "claude-code@latest"
        # Homebrew's official Chrome cask uses an unversioned download without a hash.
        {
          name = "google-chrome";
          args.require_sha = false;
        }
        "opera"
        # Launcher; set its hotkey to Control-Space in Alfred Preferences.
        "alfred"
        "chatgpt"
        "stablyai/orca/orca"
      ];
    };
  };
}
