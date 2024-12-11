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
make apply
```

### After Nix
```bash
cs setup --jvm graalvm-java21:21 // sbt, scala-cli, etc...
rustup default stable // choose a version of cargo to run
```

### NOTE
Use raycast instead of spotlight, alfred
