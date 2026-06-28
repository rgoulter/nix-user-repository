{
  specialisation = {
    gnome.configuration = {
      services = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
      system.nixos.tags = ["gnome"];
    };
    pantheon.configuration = {
      services = {
        # Pantheon conflicts with gnome
        desktopManager = {
          gnome.enable = false;
          pantheon.enable = true;
        };
        displayManager.gdm.enable = false;
        # LightDM is still configured under xserver
        xserver.displayManager.lightdm.enable = true;
      };
      system.nixos.tags = ["pantheon"];
    };
    xfce.configuration = {
      networking.networkmanager.enable = true;
      services = {
        desktopManager.gnome.enable = false;
        displayManager.gdm.enable = false;
        xserver.desktopManager.xfce.enable = true;
      };
      system.nixos.tags = ["xfce"];
    };
  };
}
