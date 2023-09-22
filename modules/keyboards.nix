{
  config,
  lib,
  pkgs,
  ...
}:
# Enable udev rules which allow flashing QMK-powered
# keyboards, # and using stlink (to flash STM MCUs)
# without sudo.
{
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [
    pkgs.stlink
  ];
}
