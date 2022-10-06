{ config, lib, pkgs, ... }:

let
  cfg = config.rgoulter.desktops;
in
{
  options.rgoulter.desktops.specialisations = {
    enable = lib.mkEnableOption "specialisation of other desktop managers";
  };

  config = {
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-extra
      # I like using Source Code Pro with Emacs
      source-code-pro
    ];

    services = {
      xserver = {
        desktopManager.gnome.enable = lib.mkDefault true;
        displayManager.gdm.enable = lib.mkDefault true;

        enable = true;

        layout = "us";
      };
    };

    specialisation = lib.mkIf cfg.specialisations.enable {
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
  };
}
