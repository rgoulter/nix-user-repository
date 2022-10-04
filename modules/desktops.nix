{ config, lib, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-extra
    # I like using Source Code Pro with Emacs
    source-code-pro
  ];

  networking.networkmanager.enable = true;

  services = {
    xserver = {
      desktopManager.xfce.enable = true;

      enable = true;

      layout = "us";
    };
  };

  specialisation = {
    gnome.configuration = {
      services.xserver = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
      system.nixos.tags = [ "gnome" ];
    };
    pantheon.configuration = {
      services.xserver = {
        desktopManager.pantheon.enable = true;
        displayManager.lightdm.enable = true;
      };
      system.nixos.tags = [ "pantheon" ];
    };
  };
}
