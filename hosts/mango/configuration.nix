{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/nixos.nix
  ];

  networking.hostName = "mango";

  # Hyprland (Wayland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Steam gaming
  programs.steam.enable = true;

  # NVIDIA + AMD GPU Prime setup
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Updated graphics setup
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # replaces old driSupport32Bit
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      mangohud
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      vulkan-loader
      vulkan-validation-layers
      mangohud
    ];
  };

  # Enable X11 (if needed)
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "amdgpu" ];
  };

  # Firmware
  hardware.enableAllFirmware = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable NoiseTorch for noise suppression
  programs.noisetorch.enable = true;

  # Disable pulseaudio (using PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Environment variables (forced to avoid duplicates)
  environment.sessionVariables = {
    LD_LIBRARY_PATH = lib.mkForce (lib.concatStringsSep ":" [
      "/run/opengl-driver/lib"
      "/run/opengl-driver-32/lib"
      "${pkgs.pipewire}/lib"
      "${pkgs.pipewire}/lib/pipewire-0.3/jack"
    ]);
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # System packages you want available globally
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    rofi
    waybar
    networkmanagerapplet
    cifs-utils
    rnnoise
    rnnoise-plugin
    ladspaPlugins
    pavucontrol
    helvum
    noisetorch
  ];

  xdg.portal.enable = true;
}

