{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      #jetbrains.datagrip
      #jetbrains.goland
      jetbrains.idea
      #jetbrains.pycharm-professional
      jetbrains.rust-rover
      #jetbrains.rider
      #jetbrains.webstorm
    ];
  };
}
