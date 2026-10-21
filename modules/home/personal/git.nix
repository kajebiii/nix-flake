{ lib, ... }: {
  # Keep Git settings while using the Git and Vim already on the machine.
  home.file.".gitconfig".text = lib.generators.toGitINI {
    user.name = "Jongbeom Kim";
    user.email = "kajebiii@gmail.com";
    checkout.defaultRemote = "origin";
    pull.ff = "only";
    push.autoSetupRemote = true;
    rerere.enabled = true;
    core.editor = "/usr/bin/vim";
  };
}
