{ config, pkgs, ... }:
{
  home-manager.backupFileExtension = "backup";
  nix.enable = false;
}

