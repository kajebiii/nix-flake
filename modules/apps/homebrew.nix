{ config, lib, pkgs, ... }:
{
  config = {	
    homebrew = {
      casks = [
        # Native command-line tools; reuse the existing terminal and editor.
        "codex"
        "claude-code"
        # Homebrew's official Chrome cask uses an unversioned download without a hash.
        {
          name = "google-chrome";
          args.require_sha = false;
        }
        "opera"
      ];
    };
  };
}
