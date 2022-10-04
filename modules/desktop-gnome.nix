{ config, lib, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-extra
    # I like using Source Code Pro with Emacs
    source-code-pro
  ];

  services = {
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;

      enable = true;

      layout = "us";

      videoDrivers = [ "nvidia" ];
    };
  };
}
