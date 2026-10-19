{ ... }: {
  system.defaults = {
    dock.orientation = "right";
    NSGlobalDomain = {
      # Match this Mac's existing keyboard repeat settings.
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };
}
