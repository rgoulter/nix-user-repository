{
  bluetooth-headset = import ./bluetooth-headset.nix;
  cloud-interactive = import ./cloud-interactive.nix;
  desktop = import ./desktop.nix;
  keyboards = import ./keyboards.nix;
  languages = import ./languages.nix;
  printing = import ./printing.nix;
  specialisations = import ./specialisations.nix;
  ssh = import ./ssh.nix;
  ssh-users = import ./ssh-users.nix;
  tailscale = import ./tailscale.nix;
  users = import ./users.nix;
  virtualization = import ./virtualization.nix;
  vn = import ./vn.nix;
  yubikey = import ./yubikey.nix;
}
