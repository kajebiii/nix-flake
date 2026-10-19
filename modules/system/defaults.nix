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

  system.activationScripts.postActivation.text =
    let
      user = lib.escapeShellArg config.system.primaryUser;
      # Merge one AppleSymbolicHotKeys entry; writing the whole dict through
      # CustomUserPreferences would replace every other shortcut ID.
      setHotKey = id: modifiers: ''
        /bin/launchctl asuser "$(/usr/bin/id -u -- ${user})" \
          /usr/bin/sudo --user=${user} --set-home -- \
          /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
            -dict-add ${toString id} '<dict>
              <key>enabled</key><true/>
              <key>value</key>
              <dict>
                <key>parameters</key>
                <array><integer>32</integer><integer>49</integer><integer>${toString modifiers}</integer></array>
                <key>type</key><string>standard</string>
              </dict>
            </dict>'
      '';
    in
    lib.mkAfter ''
      # 60: Select the previous input source -> Command-Space
      ${setHotKey 60 1048576}
      # 64: Show Spotlight search -> Option-Space
      ${setHotKey 64 524288}
      # Reload keyboard defaults so the shortcuts work without logging out.
      /bin/launchctl asuser "$(/usr/bin/id -u -- ${user})" \
        /usr/bin/sudo --user=${user} -- \
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
}
