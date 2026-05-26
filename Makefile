update:
	nix flake update
apply:
	nix-channel --update darwin
	# nix run nix-darwin -- switch --flake .
	sudo -E NIX_CONFIG="access-tokens = github.com=$(GITHUB_TOKEN)" nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake . --impure
gc:
	nix-collect-garbage
gc_full:
	sudo nix-collect-garbage -d
refresh: apply gc
