{
  config,
  lib,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headsets_with_PulseAudio
  # https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    pulseaudio.enable = false;
  };
  security = {
    # https://nixos.wiki/wiki/PipeWire
    # rtkit is optional but recommended
    rtkit.enable = true;
  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{"device.name" = "~bluez_card.*";}];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = ["hfp_hf" "hsp_hs" "a2dp_sink"];
              # mSBC: higher quality in calls.
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ: higher audio
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;

              "bluez5.autoswitch-profile" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            {"node.name" = "~bluez_input.*";}
            # Matches all outputs
            {"node.name" = "~bluez_output.*";}
          ];
          actions = {
            "node.pause-on-idle" = false;
          };
        }
      ];
    };
  };
}
