# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {
          config = {
              allowUnfree = true;
          };
      };
  in 
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./pia.nix
    ];

  nix.maxJobs = 4;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "etcetera"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nixpkgs.config = {
     allowUnfree = true;
     virtualbox.enableExtensionPack = true;
     packageOverrides = pkgs: with pkgs; rec {
        fish-foreign-env = unstable.fish-foreign-env;
    };
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     vim
     awesome
     git
     slock
  ];

  security.wrappers = {
    slock = {
      source = "${pkgs.slock}/bin/slock";
    };
  };


  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.nat.internalInterfaces = [ "enp0s20f0u1" "enp0s20f0u2" "enp0s20f0u3" "enp0s20f0u4" ];
  networking.nat.externalInterface = "wlp2s0"; 
  networking.nat.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["intel"];
  services.xserver.deviceSection = ''
        Option "TearFree" "true"
  '';
  hardware.bumblebee.enable = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.layout = "us,ua,th";
  services.xserver.xkbOptions = "grp:alt_space_toggle";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.lightdm = {
     enable = true;
  };
  services.xserver.windowManager.awesome.enable = true;

  fonts.fonts = [ pkgs.iosevka-bin ];
  users.extraUsers.yrashk = import ./users/yrashk.nix { inherit config; inherit pkgs; };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;

  hardware.bluetooth.enable = true;

  system.autoUpgrade.enable = true;

  services.logind.extraConfig = ''
  HandlePowerKey=lock
  '';

  environment.etc = {
    "wpa_supplicant.conf".text = builtins.readFile private/wpa_supplicant.conf;
  };

  # This is to enable OnlyKey configuration as per https://www.pjrc.com/teensy/49-teensy.rules
  services.udev.extraRules = builtins.readFile ./teensy.rules;

  # JACK support for realtime audio recording
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" "snd-aloop"];
  hardware.pulseaudio = {
     enable = true;
     package = pkgs.pulseaudioFull;
  };

}
