{ inputs, pkgs, ... }: {
   users.users.kevincardona = {
    home = "/Users/kevincardona";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks  = [
      "discord"
      "google-chrome"
      "karabiner-elements"
      "plex"
      "raycast"
      "spotify"
      "tailscale"
      "visual-studio-code"
      "zen"
    ];
  };
}
