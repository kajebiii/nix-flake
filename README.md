### Before Nix
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# login apple account to use brew mas (Mac App Stoer)
```

### Nix
```bash
sh <(curl -L https://nixos.org/nix/install)
git clone git@github.com:kajebiii/nix-flake.git
cd nix-flake
# Modify userName and userEmail on modules/apps/git.nix
# Modify "macstudio-jongbeomkim" to your username (check echo $HOME) on flake.nix and modules/system/home.nix
vim ...

make apply
```

### After Nix
```bash
cs setup --jvm graalvm-java21:21 // sbt, scala-cli, etc...
rustup default stable // choose a version of cargo to run
```

### NOTE
Use raycast instead of spotlight, alfred
