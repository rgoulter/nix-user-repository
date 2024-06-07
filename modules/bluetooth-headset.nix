{
  # https://nixos.wiki/wiki/PipeWire#Bluetooth_Configuration
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
      	["bluez5.enable-sbc-xq"] = true,
      	["bluez5.enable-msbc"] = true,
      	["bluez5.enable-hw-volume"] = true,
      	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headsets_with_PulseAudio
  # https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source";
          MultiProfile = "multiple";
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
    };
  };
}
