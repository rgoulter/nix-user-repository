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
        };
        displayManager = {
          gdm.enable = false;
        };
        xserver = {
          desktopManager = {
            pantheon.enable = true;
          };
          # Pantheon requires lightdm
          displayManager = {
            lightdm.enable = true;
          };
        };
      };
      system.nixos.tags = ["pantheon"];
    };
    xfce.configuration = {
      networking.networkmanager.enable = true;
      services = {
        desktopManager = {
          gnome.enable = false;
        };
        displayManager = {
          gdm.enable = false;
        };
        xserver = {
          desktopManager = {
            xfce.enable = true;
          };
        };
      };
      system.nixos.tags = ["xfce"];
    };
  };
}
