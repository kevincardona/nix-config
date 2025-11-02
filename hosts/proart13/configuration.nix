# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/nixos.nix
    ];
  
  boot.kernelParams = ["resume_offset=84408320"];

  boot.resumeDevice = "/dev/disk/by-uuid/2dd98905-1379-4bcc-9d62-8f809bf21268";

  swapDevices = [
    {
      device = "/swapfile";
      size = 35000; # size in MB (e.g. 4096 = 4 GB)
    }
  ];

  programs.steam.enable = true;

  networking.hostName = "proart13";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;  # or true, if you want the open kernel module and your GPU supports it
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

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
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


}


