# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tinynix";
  networking.networkmanager.enable = true;
  
  fileSystems."/".options = ["noatime" "autodefrag" "compress=lzo"];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "neo";
    # Auto login.
    displayManager.slim.autoLogin = true;
    displayManager.slim.defaultUser = "nion";
    windowManager.i3.enable = true;
    windowManager.default = "i3";
  };

  environment.systemPackages = with pkgs; [
     curl
     firefox
     rofi
     vim
     wget
   ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.nion = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager"];
    home = "/home/nion";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
