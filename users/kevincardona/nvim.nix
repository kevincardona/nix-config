{ config, pkgs, lib, inputs, ... }:

let
  nvimConfig = inputs.nvim;
in {
  home.activation.copyNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Copying Neovim config from flake..."
    rm -rf $HOME/.config/nvim
    cp -r --no-preserve=mode,ownership ${nvimConfig} $HOME/.config/nvim
  '';

  programs.neovim.enable = true;

  home.packages = with pkgs; [
    rustc
    cargo
    nodejs
  ];
}

