{
  config,
  lib,
  pkgs,
  ...
}: {
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
      passwordAuthentication = false;
    };
  };
}
