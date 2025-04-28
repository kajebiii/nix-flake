{ config, lib, pkgs, ... }:
{
  config = {	
    homebrew = {
      brews = [
        "asdf"
        "mas"
        "jenv"
        "bufbuild/buf/buf"
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
        "docker"
        "slack"
        "wrike"
        "figma"
        "wireshark"
        "1password"
        "unity-hub"
      ];
      masApps = {
        "KakaoTalk" = 869223134;
      };
    };
  };
}
