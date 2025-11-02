{ config, pkgs, lib, dotfiles, ... }:

let
  zshConfig = dotfiles.zsh;
in
{
  home.file.".zshrc".source = "${zshConfig}/.zshrc";
  home.file.".zsh_aliases".source = "${zshConfig}/.zsh_aliases";
  home.file.".zsh_functions".source = "${zshConfig}/.zsh_functions";

  # Add Nix paths to zshenv
  home.file.".zshenv".text = ''
    # Ensure Nix paths are in PATH with proper order (wrappers first for setuid binaries)
    export PATH=/run/wrappers/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH
  '';

  home.activation.installOhMyZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export ZSH="$HOME/.oh-my-zsh"
    PLUGIN_DIR="$ZSH/custom/plugins"

    if [ ! -d "$ZSH" ]; then
      echo "Installing Oh My Zsh..."
      ${pkgs.git}/bin/git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
    fi

    # Install external plugins
    mkdir -p "$PLUGIN_DIR"

    [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ] && \
      ${pkgs.git}/bin/git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"

    [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ] && \
      ${pkgs.git}/bin/git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"

    [ ! -d "$PLUGIN_DIR/zsh-completions" ] && \
      ${pkgs.git}/bin/git clone https://github.com/zsh-users/zsh-completions "$PLUGIN_DIR/zsh-completions"
  '';
  # programs.zsh.enable = true;
}

