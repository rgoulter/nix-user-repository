{pkgs, ...}:
# Enable udev rules which allow flashing QMK-powered
# keyboards, # and using stlink (to flash STM MCUs)
# without sudo.
{
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [
    pkgs.stlink
    (pkgs.writeTextFile {
      name = "wch.rules";
      destination = "/lib/udev/rules.d/50-wch.rules";
      text = ''
        # WCHISP
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8010", GROUP="plugdev", MODE="0660"

        # Allow wchisp to be used without sudo.
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="4348", ATTRS{idProduct}=="55e0", MODE="660", GROUP="plugdev", TAG+="uaccess"
        # CH32X:
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55e0", MODE="660", GROUP="plugdev", TAG+="uaccess"

        # Allow WCH-Link to be used without sudo.
        SUBSYSTEM=="usb", ATTR{idVendor}="1a86", ATTR{idProduct}=="8010", MODE="660", GROUP="plugdev", TAG+="uaccess"
      '';
    })
  ];
}
