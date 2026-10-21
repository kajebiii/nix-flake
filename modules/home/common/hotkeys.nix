{ lib, ... }:
let
  # Merge one AppleSymbolicHotKeys entry; writing the whole dict would
  # replace every other shortcut ID.
  setHotKey = id: modifiers: ''
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
in {
  home.activation.symbolicHotKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # 60: Select the previous input source -> Command-Space
    ${setHotKey 60 1048576}
    # 64: Show Spotlight search -> Option-Space
    ${setHotKey 64 524288}
    # Reload keyboard defaults so the shortcuts work without logging out.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
