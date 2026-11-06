# Offline account: standard user for private local work. No Git identity or keys;
# it clones over HTTPS read-only and applies this with `make home`.
{ ... }: {
  imports = [
    ../common
  ];

  home.username = "kajebiii.offline";
  home.homeDirectory = "/Users/kajebiii.offline";
}
