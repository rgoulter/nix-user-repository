# A user named `rgoulter`,
# for headless environments.
{
  users.users.rgoulter = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmQ9/u9qV9Vvy2pbcPtGiAmIrhXdi/vY6IesJ5RYpS4"
    ];
  };
}
