# offline.nix - NixOS configuration for an air-gapped
#  NixOS ISO, booted from a USB drive to manage GnuPG keys:
#  generating keys, extending expiry, paperkey backups,
#  and provisioning a YubiKey.
#  It also includes KeePassXC, e.g. for generating a
#  diceware passphrase.
#  Networking is disabled; printing is kept for paperkey backups.
{
  lib,
  pkgs,
  ...
}: let
  gpg-quick-generate-master-key =
    pkgs.writeScriptBin
    "gpg-quick-generate-master-key"
    (pkgs.lib.readFile ../../scripts/gpg-quick-generate-master-key.sh);
  gpg-extend-expiry = pkgs.callPackage ../../pkgs/gpg-extend-expiry {};
  offline-gpg-docs = pkgs.callPackage ../../pkgs/offline-gpg-docs {};
  offline-gpg = pkgs.writeShellScriptBin "offline-gpg" ''
    exec ${pkgs.just}/bin/just --justfile /etc/offline-gpg/justfile \
      --working-directory "$PWD" "$@"
  '';
in {
  # NVIDIA applies to the ISO only; VMs keep the default graphics.
  image.modules.iso = {
    hardware.nvidia.open = false;
    services.xserver.videoDrivers = ["nvidia" "modesetting" "fbdev"];

    isoImage = {
      makeEfiBootable = true;
      makeUsbBootable = true;
    };
  };

  environment.etc."offline-gpg/justfile".source = ../../scripts/offline-gpg.justfile;

  environment.gnome.excludePackages = [pkgs.gnome-tour];
  environment.systemPackages = with pkgs; [
    bash
    fish
    gawk
    gnupg
    gpg-extend-expiry
    gpg-quick-generate-master-key
    just
    keepassxc
    kitty
    monkeysphere
    neovim
    offline-gpg
    offline-gpg-docs
    openssl
    paperkey
    qrencode
    yubico-piv-tool
    yubikey-manager
    yubioath-flutter
  ];

  users.motd = "GnuPG help: man offline-gpg; recipes: offline-gpg --list";

  # The machine is meant to stay air-gapped, so all networking is disabled.
  boot.blacklistedKernelModules = ["bluetooth" "btusb" "cfg80211" "mac80211"];
  hardware.bluetooth.enable = lib.mkForce false;
  networking = {
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    wireless.enable = false;
  };

  programs = {
    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    starship.enable = true;
  };

  services = {
    displayManager.autoLogin = {
      enable = true;
      user = "nixos";
    };
    gnome.core-apps.enable = false;

    pcscd.enable = true;

    printing = {
      enable = true;
      drivers = [pkgs.brlaser];
    };

    udev.packages = [
      pkgs.yubikey-personalization
    ];

    # Enable the GNOME 3 Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      excludePackages = [pkgs.xterm];

      xkb.layout = "us";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";

  time.timeZone = "Asia/Jakarta";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    password = "nixos";
    shell = pkgs.fish;
    uid = 1000;
  };
}
