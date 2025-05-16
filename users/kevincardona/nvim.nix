{ config, pkgs, lib, inputs, ... }:

let
  nvimConfig = inputs.nvim;
in
{
  home.activation.copyNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Copying Neovim config from flake..."
    rm -rf $HOME/.config/nvim
    cp -r --no-preserve=mode,ownership ${nvimConfig} $HOME/.config/nvim
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    nodejs_20  # Using a specific version that should have better binary cache support
    cargo
  ];
}

