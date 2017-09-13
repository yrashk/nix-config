# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "etcetera"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nixpkgs.config = {
     allowUnfree = true;
     packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
           config = { 
                allowUnfree = true;
                allowBroken = true;
           };
        };
     };
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     vim
     unstable.awesome
     git
     fish
  ];


  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["intel"];
  hardware.opengl.driSupport32Bit = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.layout = "us,ua,th";
  services.xserver.xkbOptions = "grp:caps_toggle,grp_led:caps";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm = {
     enable = true;
  };
  services.xserver.windowManager.awesome.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.yrashk = {
     isNormalUser = true;
     description = "Yurii Rashkovskii";
     home = "/home/yrashk";
     extraGroups = ["wheel"];
     uid = 1000;
     hashedPassword = "$6$YZ2znbV6G4$dbKGu7E/ywwHVmZy9Ez3nenesHncLyKqQKYwdWo9QTLerhDH3NCxleuT8fl5vDCGEzDQrLwpd/VMmDgy90D3q1"; 
     shell = "/run/current-system/sw/bin/fish";
   };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
