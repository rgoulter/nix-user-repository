{ pkgs, ... }:

# A user named `rgoulter`,
# for graphical desktop.
{
  # programs.fish.enable = true;
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
    # Using fish as default shell breaks GDM.
    # shell = pkgs.fish;
  };
}
