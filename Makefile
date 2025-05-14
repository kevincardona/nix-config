HOST ?= proart13
FLAKE_DIR ?= $(HOME)/nix-config

.PHONY: update switch clean-generations clean-boot full-clean

update:
	cd $(FLAKE_DIR) && nix flake update

switch:
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOST)

clean-generations:
	sudo nix profile wipe-history
	sudo nix store gc

clean-boot:
	sudo nixos-rebuild boot --flake $(FLAKE_DIR)#$(HOST)

full-clean: clean-generations clean-boot

