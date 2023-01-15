{
  config,
  lib,
  pkgs,
  ...
}:
# A user named `rgoulter`,
# for graphical desktop.
{
  users.users.rgoulter = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "docker"
      "libvirtd"
      "networkmanager"
      "wheel"
      "vboxusers"
    ];
  };
}
