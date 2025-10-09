{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/nixos.nix
  ];

  networking.hostName = "mango";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  ########################################
  ## Display / NVIDIA / Wayland
  ########################################
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false; # use proprietary driver for full support
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      vaapiVdpau
      nvidia-vaapi-driver
      ffmpeg-full
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  ########################################
  ## Audio
  ########################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ########################################
  ## Environment Variables (NVIDIA + Wayland)
  ########################################
  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";

    # NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";

    # Firefox / VAAPI
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_WEBRENDER = "1";
  };

  ########################################
  ## Basic System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    vulkan-tools
    pavucontrol
    nvidia-vaapi-driver
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true; # Optional - for smoother Wayland Steam sessions
  };

  ########################################
  ## Wayland Integration
  ########################################
  xdg.portal.enable = true;

  ########################################
  ## Unfree Packages & Flakes
  ########################################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

