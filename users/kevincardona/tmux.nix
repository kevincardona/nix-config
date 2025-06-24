{ config, pkgs, lib, dotfiles, ... }:

let
  tmuxConfig = dotfiles.tmux;
  scriptsDir = dotfiles.scripts;
in
{
  # We will manually manage tmux configs
  programs.tmux.enable = false;

  home.packages = [
    pkgs.tmux
  ];

  home.file.".local/bin/tmux-sessionizer".source = "${scriptsDir}/.local/bin/tmux-sessionizer";
  home.file.".config/tmux/tmux.conf".source = "${tmuxConfig}/tmux.conf";
}

