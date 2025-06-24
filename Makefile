HOST ?= mango
FLAKE_DIR ?= $(HOME)/nix-config
EXPERIMENTAL_FLAGS = --option experimental-features "nix-command flakes"

.PHONY: update switch clean-generations clean-boot full-clean

update:
	cd $(FLAKE_DIR) && nix $(EXPERIMENTAL_FLAGS) flake update

switch:
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOST) $(EXPERIMENTAL_FLAGS)

clean-generations:
	sudo nix $(EXPERIMENTAL_FLAGS) profile wipe-history
	sudo nix $(EXPERIMENTAL_FLAGS) store gc

clean-boot:
	sudo nixos-rebuild boot --flake $(FLAKE_DIR)#$(HOST) $(EXPERIMENTAL_FLAGS)

full-clean: clean-generations clean-boot

