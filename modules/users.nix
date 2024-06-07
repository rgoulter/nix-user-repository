# A user named `rgoulter`,
# for graphical desktop.
{
  users.users.rgoulter = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "camera"
      "dialout"
      "docker"
      "libvirtd"
      "networkmanager"
      "wheel"
      "vboxusers"
    ];
  };
}
