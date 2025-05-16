{ config, pkgs, lib, dotfiles, ... }:

let
  tmuxConfig = dotfiles.tmux;
in
{
  programs.tmux.enable = false;

  home.packages = [
    pkgs.tmux
  ];

  home.file.".config/tmux/tmux.conf".source = "${tmuxConfig}/tmux.conf";
}

