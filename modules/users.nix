{
  config,
  lib,
  pkgs,
  ...
}:
# A user named `rgoulter`.
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
