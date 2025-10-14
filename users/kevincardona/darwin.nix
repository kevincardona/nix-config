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
      "ffmpeg"
      "colima"
      "docker"
      "docker-buildx"
      "docker-compose"
    ];
    masApps = {
      # "WireGuard" = 1451685025;
      "Bitwarden" = 1352778147;
      "WhatsApp Messenger" = 310633997;
    };
    casks = [
      "altserver"
      "blender"
      "discord"
      "firefox@developer-edition"
      "godot-mono"
      "google-chrome"
      "karabiner-elements"
      "lunar"
      "microsoft-remote-desktop"
      "nordvpn"
      "ollama"
      "plex"
      "postman"
      "raspberry-pi-imager"
      "rectangle"
      "spotify"
      "tailscale"
      "visual-studio-code"
    ];
  };

  environment.variables = {
    DOCKER_HOST = "unix:/Users/kevincardona/.colima/default/docker.sock";
  };
}

