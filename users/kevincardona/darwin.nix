{ inputs, pkgs, ... }: {

  system.primaryUser = "kevincardona";

  users.users.kevincardona = {
    home = "/Users/kevincardona";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = [
      "lunar"
      "discord"
      "google-chrome"
      "karabiner-elements"
      "plex"
      "raycast"
      "spotify"
      "tailscale"
      "visual-studio-code"
      "zen"
      "brave-browser"
    ];
  };
}
