{ config, lib, pkgs, ... }:
{
  config = {
    fonts.packages = with pkgs; [
      meslo-lgs-nf
      pretendard
      pretendard-jp
      d2coding
      nerd-fonts.symbols-only
    ];
  };
}