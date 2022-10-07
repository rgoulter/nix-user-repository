{
  bluetooth-headset = import ./bluetooth-headset.nix;
  desktop = import ./desktop.nix;
  keyboards = import ./keyboards.nix;
  printing = import ./printing.nix;
  specialisations = import ./specialisations.nix;
  users = import ./users.nix;
  virtualization = import ./virtualization.nix;
  vn = import ./vn.nix;
  yubikey = import ./yubikey.nix;
}
