{ lib, ... }: {
  # Keep Git settings while using the Git and Vim already on the machine.
  home.file.".gitconfig".text = lib.generators.toGitINI {
    # The lab email maps commits to the kajebiii-lab GitHub account.
    user.name = "Jongbeom Kim";
    user.email = "kajebiii.lab@gmail.com";
    checkout.defaultRemote = "origin";
    pull.ff = "only";
    push.autoSetupRemote = true;
    rerere.enabled = true;
    core.editor = "/usr/bin/vim";
  };
}

