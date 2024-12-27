{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    home.packages = (with pkgs; [
      awscli2
      saml2aws
      btop htop
      chafa
      fd
      ffmpeg
      fzf
      imagemagick
      exiftool
      jq
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      nodejs
      pnpm
      yarn
      # nodePackages.pnpm
      # nodePackages.yarn
      python311
      pv
      ripgrep
      thefuck
      tmux
      virtualenv
      wget
      yq
      k9s
      grpcurl
      rustup
      # vault
      argo-rollouts
      visualvm
      terraform-config-inspect
      redis
      istioctl
      go-migrate
      colima
      minikube
      lima
      krew
      kustomize
      pipx
      dotnet-sdk_8
      brotli
      wrangler
      azure-cli
      google-cloud-sdk 
      coursier
      protobuf
      grpcui
      discord
      fnm
    ]) ++ (with pkgs.unstable; [
      go
    ]);
  };
}
