{ config, ... }: {
  home.sessionVariables.HOMEBREW_NO_ANALYTICS = "1";

  # Login shells: runs after /etc/zprofile's path_helper reorders PATH.
  home.file.".zprofile".text = ''
    export PATH="/opt/homebrew/bin:$PATH"
    if [ -r "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh" ]; then
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    fi
  '';

  # Every shell, including non-interactive ones that agents spawn.
  home.file.".zshenv".text = ''
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    case ":$PATH:" in *":/opt/homebrew/bin:"*) ;; *) export PATH="/opt/homebrew/bin:$PATH" ;; esac
  '';
}
