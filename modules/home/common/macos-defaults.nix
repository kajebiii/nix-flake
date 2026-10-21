{ lib, ... }: {
  # User-level macOS defaults; applied by each user with `make home`.
  targets.darwin.defaults = {
    "com.apple.finder" = {
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    "com.apple.dock" = {
      autohide = true;
      show-recents = false;
      orientation = "right";
      mru-spaces = false;
    };
    "com.apple.menuextra.clock" = {
      ShowDate = 1;
      ShowSeconds = true;
    };
    NSGlobalDomain = {
      # Finder's "show all extensions" lives in the global domain.
      AppleShowAllExtensions = true;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  # Home Manager writes defaults but does not restart Dock or Finder.
  home.activation.reloadDockFinder = lib.hm.dag.entryAfter [ "setDarwinDefaults" ] ''
    /usr/bin/killall Dock Finder 2>/dev/null || true
  '';
}
