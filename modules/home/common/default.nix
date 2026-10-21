{ ... }: {
  imports = [
    ./shell.nix
    ./macos-defaults.nix
    ./hotkeys.nix
  ];

  # Keep the value used by the previous nix-darwin-integrated setup.
  home.stateVersion = "23.11";
}
