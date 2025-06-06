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
}

