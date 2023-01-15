{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.tailscale];
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
    allowedTCPPorts = [22];
  };
  services = {
    tailscale.enable = true;
  };
}
