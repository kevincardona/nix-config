# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/nixos.nix
    ];

  programs.steam.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  networking.hostName = "mango";

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # or true, if you want the open kernel module and your GPU supports it
    nvidiaSettings = true;

    prime = {
      offload.enable = true;
      sync.enable = false;

      # Bus ID of the AMD GPU. You can find it using lspci, either under 3D or VGA
      amdgpuBusId = "PCI:6:00:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:00:0";
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa.drivers
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa.drivers
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  environment.systemPackages = [
    pkgs.dunst
    pkgs.libnotify
    pkgs.rofi-wayland
    pkgs.waybar
    pkgs.networkmanagerapplet
  ];

  xdg.portal.enable = true;

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  hardware.enableAllFirmware = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.sudo.enable = true;
}

