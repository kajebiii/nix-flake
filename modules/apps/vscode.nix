{ config, lib, pkgs, ... }:
let
  sudo = "/usr/bin/sudo";
  user = "macstudio-jongbeomkim";
  sourcePath = "~${user}/nix-flake/modules/apps/vscode";
  targetPath = "~${user}/Library/'Application Support'/Code/User";
  # targetPath = "~${user}/test/test/'test test'";
  mkSymlink = oldFileName: newFileName: ''
    ${sudo} -u ${user} ${lib.getExe' pkgs.coreutils "ln"} -nsf ${sourcePath}/${oldFileName} ${targetPath}/${newFileName}
  '';
in
{
  config = {
    system.activationScripts = {
      postUserActivation = {
        text = ''
          ${sudo} -u ${user} mkdir -p ${targetPath}
          ${mkSymlink "settings.json5" "settings.json"}
        '';
      };
    };
    environment.systemPackages = with pkgs; [ vscode ];
    home.programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        extensions = with pkgs.unstable.vscode-extensions; [
          ## Language Supports
          #golang.go                     # Go
          bbenoist.nix                  # Nix
          #ms-python.python              # Python
          #rust-lang.rust-analyzer       # Rust
          #hashicorp.terraform           # Terraform
          #tamasfe.even-better-toml      # TOML
          redhat.vscode-yaml            # YAML
          tim-koehler.helm-intellisense # Helm
          ms-kubernetes-tools.vscode-kubernetes-tools # Kubernetes
          ## Vim
          vscodevim.vim
          ## Theme
          jdinhlife.gruvbox
          vscode-icons-team.vscode-icons
          ## Copilot
          github.copilot
          ## Git
          eamodio.gitlens
          ## Markdown
          yzhang.markdown-all-in-one
          ## ESLint
          dbaeumer.vscode-eslint
          ## Prettier
          esbenp.prettier-vscode
          ## Scala
          scalameta.metals
          scala-lang.scala
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "markdown-footnotes";
            publisher = "bierner";
            version = "0.1.1";
            sha256 = "sha256-h/Iyk8CKFr0M5ULXbEbjFsqplnlN7F+ZvnUTy1An5t4=";
          }
        ];
      };
    };
  };
}
