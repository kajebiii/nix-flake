SYSTEM_CONFIG ?= macbook-m5-jongbeomkim
HOME_CONFIG   ?= $(shell id -un)
ADMIN_USER    := jongbeom.kim
NIX_FLAGS = --extra-experimental-features "nix-command flakes"
# Forward only the config file path to sudo, never a token or the full environment.
NIX_USER_CONF_FILES ?= $(if $(XDG_CONFIG_HOME),$(XDG_CONFIG_HOME),$(HOME)/.config)/nix/nix.conf
export NIX_USER_CONF_FILES

# Last applied commits, used to show what changed before running as root or admin.
HOME_STATE   := $(HOME)/.local/state/nix-flake/last-home-rev
LAST_APPLIED := $(shell /run/current-system/sw/bin/darwin-version --configuration-revision 2>/dev/null | sed 's/-dirty$$//')
LAST_HOME    := $(shell cat "$(HOME_STATE)" 2>/dev/null)
# modules/home/lab only ever runs as the AI account itself.
REVIEW_PATHS  = . ':(exclude)modules/home/lab'

# $(1) = base revision, $(2) = what is about to run
define review
	@if [ -n "$(1)" ] && git cat-file -e "$(1)^{commit}" 2>/dev/null; then \
	  echo "== $(2): changes since $(1) (modules/home/lab excluded) =="; \
	  git --no-pager diff --stat "$(1)" -- $(REVIEW_PATHS); \
	  git --no-pager diff "$(1)" -- $(REVIEW_PATHS); \
	else \
	  echo "== $(2): no known last-applied revision; review the whole tree yourself =="; \
	  git --no-pager status --short; \
	fi
	@printf "Proceed? [y/N] "; read ans; [ "$$ans" = y ] || { echo "aborted"; exit 1; }
endef

.DEFAULT_GOAL := build
.PHONY: build apply home update gc gc_full

# System: admin only. Homebrew apps and Nix settings; runs as root.
build:
	nix $(NIX_FLAGS) build ".#darwinConfigurations.$(SYSTEM_CONFIG).system" --out-link result
apply: build
	$(call review,$(LAST_APPLIED),make apply (runs as root))
	sudo env NIX_USER_CONF_FILES="$(NIX_USER_CONF_FILES)" ./result/sw/bin/darwin-rebuild switch --flake ".#$(SYSTEM_CONFIG)"

# Home: each user for themselves, no sudo. Only the admin gets the review step.
home:
ifeq ($(HOME_CONFIG),$(ADMIN_USER))
	$(call review,$(LAST_HOME),make home as $(ADMIN_USER))
endif
	nix $(NIX_FLAGS) run ".#home-manager" -- switch --flake ".#$(HOME_CONFIG)"
	@mkdir -p "$(dir $(HOME_STATE))" && git rev-parse HEAD > "$(HOME_STATE)"

update:
	nix $(NIX_FLAGS) flake update
gc:
	nix-collect-garbage
gc_full:
	sudo nix-collect-garbage -d
