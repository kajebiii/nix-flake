# Admin account: personal use and system maintenance.
{ ... }: {
  imports = [
    ../common
    ./git.nix
  ];

  home.username = "jongbeom.kim";
  home.homeDirectory = "/Users/jongbeom.kim";
}
