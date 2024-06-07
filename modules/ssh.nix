{
  networking = {
    firewall = {
      allowedTCPPorts = [
        22
      ];
    };
  };
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
