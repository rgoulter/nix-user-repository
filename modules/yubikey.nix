{ config, lib, pkgs, ... }:

{
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security = {
    pam.u2f.enable = true;
  };
  services = {
    pcscd.enable = true;

    udev = {
      packages = [
        pkgs.yubikey-personalization
      ];
    };
  };
}
