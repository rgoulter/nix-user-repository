{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.rgoulter.tailscale;
in {
  options.rgoulter.tailscale = {
    advertise-exit-node = lib.mkEnableOption "offer to be an exit node for internet traffic for the tailnet";
    enable-tailscale-up-auto = lib.mkEnableOption "tailscale up auto";
  };
  config = {
    environment.systemPackages = [pkgs.tailscale];
    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
      allowedTCPPorts = [22];
    };
    services = {
      tailscale.enable = true;
    };
    boot.kernel.sysctl = lib.mkif cfg.advertise-exit-node {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
    systemd.services.tailscale-up-auto = lib.mkIf cfg.enable-tailscale-up-auto {
      description = "Automatic connection to Tailscale";
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      path = with pkgs; [jq tailscale];
      script = let
        advertiseExitNode =
          if cfg.advertise-exit-node
          then "--advertise-exit-node"
          else "";
      in ''
        sleep 2
        status="$(tailscale status -json | jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi
        tailscale up --authkey=file:/run/keys/auth-key ${advertiseExitNode}
      '';
    };
  };
}
