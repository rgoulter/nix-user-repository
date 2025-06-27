{pkgs, ...}: {
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
    # By default, SSH_AUTH_SOCK is set to the gnome-keyring ssh-agent socket.
    # We want to use the GPG agent instead.
    gnome.gcr-ssh-agent.enable = false;

    pcscd.enable = true;

    udev = {
      packages = [
        pkgs.yubikey-personalization
      ];
    };
  };
}
