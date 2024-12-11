### Before Nix
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# login apple account to use brew mas (Mac App Stoer)

### Nix
sh <(curl -L https://nixos.org/nix/install)
make apply

### After Nix
cs setup --jvm graalvm-java21:21 // sbt, scala-cli, etc...
rustup default stable // choose a version of cargo to run

### NOTE
Use raycast instead of spotlight, alfred
