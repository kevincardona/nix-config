HOST ?= $(shell hostname)
FLAKE_DIR ?= $(HOME)/nix-config
EXPERIMENTAL_FLAGS = --option experimental-features "nix-command flakes"

# Detect platform (Linux or Darwin)
UNAME_S := $(shell uname -s)

# Set rebuild command based on OS
ifeq ($(UNAME_S),Linux)
	REBUILD_CMD = sudo nixos-rebuild
else ifeq ($(UNAME_S),Darwin)
	REBUILD_CMD = darwin-rebuild
else
	$(error Unsupported OS: $(UNAME_S))
endif

.PHONY: update switch clean-generations clean-boot full-clean

update:
	cd $(FLAKE_DIR) && nix $(EXPERIMENTAL_FLAGS) flake update

switch:
	$(REBUILD_CMD) switch --flake $(FLAKE_DIR)#$(HOST) $(EXPERIMENTAL_FLAGS)

clean-generations:
	sudo nix $(EXPERIMENTAL_FLAGS) profile wipe-history
	sudo nix $(EXPERIMENTAL_FLAGS) store gc

clean-boot:
	$(REBUILD_CMD) boot --flake $(FLAKE_DIR)#$(HOST) $(EXPERIMENTAL_FLAGS)

full-clean: clean-generations clean-boot

