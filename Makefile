CONFIG ?= macbook-m5-jongbeomkim
NIX_FLAGS = --extra-experimental-features "nix-command flakes"
# Forward only the config file path to sudo, never a token or the full environment.
NIX_USER_CONF_FILES ?= $(if $(XDG_CONFIG_HOME),$(XDG_CONFIG_HOME),$(HOME)/.config)/nix/nix.conf
export NIX_USER_CONF_FILES

.DEFAULT_GOAL := build
.PHONY: build apply update gc gc_full refresh

build:
	nix $(NIX_FLAGS) build ".#darwinConfigurations.$(CONFIG).system" --out-link result
apply: build
	sudo env NIX_USER_CONF_FILES="$(NIX_USER_CONF_FILES)" ./result/sw/bin/darwin-rebuild switch --flake ".#$(CONFIG)"
update:
	nix $(NIX_FLAGS) flake update
gc:
	nix-collect-garbage
gc_full:
	sudo nix-collect-garbage -d
refresh: apply gc
