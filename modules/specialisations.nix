{ config, lib, pkgs, ... }:

{
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
        # Pantheon conflicts with gnome
        desktopManager = {
          gnome.enable = false;
          pantheon.enable = true;
        };
        # Pantheon requires lightdm
        displayManager = {
          gdm.enable = false;
          lightdm.enable = true;
        };
      };
      system.nixos.tags = [ "pantheon" ];
    };
    xfce.configuration = {
      networking.networkmanager.enable = true;
      services.xserver = {
        desktopManager = {
          gnome.enable = false;
          xfce.enable = true;
        };
        displayManager = {
          gdm.enable = false;
        };
      };
      system.nixos.tags = [ "gnome" ];
    };
  };
}
