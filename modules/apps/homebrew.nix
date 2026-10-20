{ config, lib, pkgs, ... }:
{
  config = {	
    homebrew = {
      # Orca is distributed through its maintainer's tap, not homebrew-cask.
      taps = [ "stablyai/orca" ];
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
