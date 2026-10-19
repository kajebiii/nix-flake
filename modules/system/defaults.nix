{ config, lib, ... }: {
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "right";
      mru-spaces = false;
    };
    menuExtraClock = {
      ShowDate = 1;
      ShowSeconds = true;
    };
    NSGlobalDomain = {
      # Match this Mac's existing keyboard repeat settings.
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  system.activationScripts.postActivation.text = lib.mkAfter ''
    # ID 60 selects the previous input source. Merge only this shortcut;
    # writing AppleSymbolicHotKeys through CustomUserPreferences replaces all IDs.
    /bin/launchctl asuser "$(/usr/bin/id -u -- ${lib.escapeShellArg config.system.primaryUser})" \
      /usr/bin/sudo --user=${lib.escapeShellArg config.system.primaryUser} --set-home -- \
      /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
        -dict-add 60 '<dict>
          <key>enabled</key><true/>
          <key>value</key>
          <dict>
            <key>parameters</key>
            <array><integer>32</integer><integer>49</integer><integer>1048576</integer></array>
            <key>type</key><string>standard</string>
          </dict>
        </dict>'
  '';
}
