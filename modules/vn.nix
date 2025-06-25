{pkgs, ...}:
# Enable Vietnamese IME.
{
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    pkgs.fcitx5-unikey
    pkgs.fcitx5-gtk
  ];
}
