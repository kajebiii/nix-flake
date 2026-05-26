{ config, lib, pkgs, ... }:
{
  config = {	
    homebrew = {
      brews = [
        "asdf"
        "mas"
        "jenv"
        "bufbuild/buf/buf"
        "gh"
        "pre-commit"
      ];
      casks = [
        ## Basic apps
        "google-chrome"
        "iterm2"
        "notion"
        "telegram"
        "sublime-text"
        #"librewolf"
        #"spotify"
        ## Dev tools
        "podman-desktop"
        "postman"
        "zed"
        ## macOS tools
        "fuwari"
        "iina"
        "insomnia"
        "maccy"
        ## For work
        "docker-desktop"
        "slack"
        "wrike"
        "figma"
        "wireshark-app"
        "1password"
        "unity-hub"
        "steam"
        "manaflow-ai/cmux/cmux"
        "steipete/tap/codexbar"
        "codex"
        "codex-app"
      ];
      masApps = {
        "KakaoTalk" = 869223134;
      };
    };
  };
}
