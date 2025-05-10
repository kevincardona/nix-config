{ config, pkgs, lib, dotfiles, ... }:

let
  tmuxConfig = dotfiles.tmux;
in
{
  home.file.".tmux.conf".source = "${tmuxConfig}/.tmux.conf";

  home.activation.installTPM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export TPM="$HOME/.tmux/plugins/tpm"

    if [ ! -d "$TPM" ]; then
      echo "Installing TPM..."
      ${pkgs.git}/bin/git clone --depth=1 https://github.com/tmux-plugins/tpm.git "$TPM"
    fi
  '';

  programs.tmux.enable = true;
}



