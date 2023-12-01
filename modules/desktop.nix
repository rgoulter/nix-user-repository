{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  fonts.packages = with pkgs; [
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

      excludePackages = [ pkgs.xterm ];

      layout = "us";
    };
  };
}
