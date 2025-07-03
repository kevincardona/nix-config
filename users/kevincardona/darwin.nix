{ inputs, pkgs, ... }: {

  system.primaryUser = "kevincardona";

  users.users.kevincardona = {
    home = "/Users/kevincardona";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    masApps = {
      # "WireGuard" = 1451685025;
      "Bitwarden" = 1352778147;
      "WhatsApp Messenger" = 310633997;
    };
    casks = [
      "ollama"
      "ultimaker-cura"
      "balenaetcher"
      "raspberry-pi-imager"
      "discord"
      "godot"
      "google-chrome"
      "flutter"
      "karabiner-elements"
      "lunar"
      "nordvpn"
      "plex"
      "postman"
      "rancher"
      "rectangle"
      "spotify"
      "tailscale"
      "visual-studio-code"
      "firefox@developer-edition"
    ];
  };
}

