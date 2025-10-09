{ config, pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kevincardona = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/kevincardona";
    description = "Kevin Cardona";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];
      settings = {
        # mac/vim/meta shortcuts (from before)
        meta = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };

        alt = {
          c = "C-c";
          v = "C-v";
          x = "C-x";
          z = "C-z";
          a = "C-a";
          s = "C-s";
          t = "C-t";
          w = "C-w";
          q = "C-q";
          n = "C-n";
          p = "C-p";
          f = "C-f";
          r = "C-r";
          m = "C-m";
          l = "C-l";
        };

        altshift = {
          leftbracket = "C-S-tab";
          rightbracket = "C-tab";
        };

        # --- Media controls
        base = {
          f7 = "prevsong"; # F7 → previous track
          f8 = "playpause"; # F8 → play/pause
          f9 = "nextsong"; # F9 → next track
          f10 = "mute"; # F10 → mute/unmute
          f11 = "voldown"; # F11 → volume down
          f12 = "volup"; # F12 → volume up
        };
      };
    };
  };
}
