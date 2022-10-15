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
  services.udev = {
    # https://docs.qmk.fm/#/faq_build?id=linux-udev-rules
    extraRules = ''
      # Atmel DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"

      # STM32 DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"

      # STM32duino 1eaf:0003
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", TAG+="uaccess"
    '';
    packages = [
      pkgs.stlink
    ];
  };
}
