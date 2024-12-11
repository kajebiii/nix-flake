update:
	nix flake update
apply:
	nix-channel --update darwin
	# nix run nix-darwin -- switch --flake .
	nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake .
gc:
	nix-collect-garbage
gc_full:
	sudo nix-collect-garbage -d
refresh: apply gc
