{
  lib,
  pkgs,
  ...
}: {
  environment.gnome.excludePackages = [pkgs.gnome-tour];

  fonts.packages = with pkgs; [
    noto-fonts
    # I like using Source Code Pro with Emacs
    source-code-pro
  ];

  services = {
    desktopManager.gnome.enable = lib.mkDefault true;
    displayManager.gdm.enable = lib.mkDefault true;
    xserver = {
      enable = true;

      excludePackages = [pkgs.xterm];

      xkb.layout = "us";
    };
  };
}
