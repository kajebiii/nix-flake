{ config, lib, pkgs, ... }:
{
  config = {	
    homebrew = {
      brews = [
        "asdf"
        "mas"
        "jenv"
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
      ];
      masApps = {
        "KakaoTalk" = 869223134;
      };
    };
  };
}
