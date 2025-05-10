{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.username = "kevincardona";
  home.homeDirectory = "/home/kevincardona";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./hyprland.nix
    (import ./tmux.nix { inherit config pkgs lib; dotfiles = inputs.dotfiles; })
    (import ./zsh.nix { inherit config pkgs lib; dotfiles = inputs.dotfiles; })
    (import ./nvim.nix { inherit config pkgs lib inputs; })
  ];

  home.packages = with pkgs; [
    curl
    discord
    fzf
    ghostty
    kitty
    git
    htop
    jq
    nodejs
    ripgrep
    spotify
    stow
    tmux
    wget
    rsync
    prismlauncher
  ] ++ (lib.optionals isDarwin [
    tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    gcc
    rustc
    cargo
    firefox
    vscode
    fastfetch
    networkmanager
    pciutils
    wofi
    usbutils
    wl-clipboard
    hyprland
    openrgb
    gnumake
    (pkgs.writeShellScriptBin "prime-run" ''
      __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
    '')
  ]);

  services.swaync.enable = true;
}

