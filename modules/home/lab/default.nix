# AI account: standard user, applies this with `make home` and no sudo.
{ ... }: {
  imports = [
    ../common
    ./git.nix
  ];

  home.username = "kajebiii.lab";
  home.homeDirectory = "/Users/kajebiii.lab";
}
