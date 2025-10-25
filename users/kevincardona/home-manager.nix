{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.username = "kevincardona";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    (import ./nvim.nix { inherit config pkgs lib inputs; })
    (import ./tmux.nix { inherit config pkgs lib; dotfiles = inputs.dotfiles; })
    (import ./zsh.nix { inherit config pkgs lib; dotfiles = inputs.dotfiles; })
  ];

  home.activation.ensureConfigDir = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    mkdir -p $HOME/.config
  '';

  home.packages = with pkgs; [
    curl
    fzf
    git
    htop
    jq
    ripgrep
    stow
    vim
    wget
    rsync
    go
  ] ++ (lib.optionals isDarwin [
    tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    discord
    fastfetch
    firefox-devedition
    gcc
    ghostty
    gnumake
    godot
    kitty
    networkmanager
    openrgb
    pciutils
    rofi
    rpi-imager
    spotify
    usbutils
    vscode
    wl-clipboard
    wofi
    xremap
    (btop.override { rocmSupport = true; cudaSupport = true; })
    (pkgs.writeShellScriptBin "prime-run" ''
      __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
    '')
  ]);


}

