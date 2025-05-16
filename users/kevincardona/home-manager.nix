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
    git
    htop
    jq
    ripgrep
    stow
    vim
    wget
    rsync
  ] ++ (lib.optionals isDarwin [
    tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    fastfetch
    firefox
    gcc
    ghostty
    gnumake
    kitty
    mangohud
    networkmanager
    nodejs
    openrgb
    pciutils
    rofi
    usbutils
    vscode
    wl-clipboard
    wofi
    xremap
    (pkgs.writeShellScriptBin "prime-run" ''
      __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
    '')
  ]);


}

