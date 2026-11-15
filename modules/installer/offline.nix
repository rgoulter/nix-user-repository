# offline.nix - NixOS configuration for an "offline"
#  NixOS ISO, for e.g. generating a KeePassXC diceware
#  passphrase, or manipulating PGP / GnuPG keys.
{
  lib,
  pkgs,
  ...
}: let
  gpg-quick-generate-master-key =
    pkgs.writeScriptBin
    "gpg-quick-generate-master-key"
    (pkgs.lib.readFile ../../scripts/gpg-quick-generate-master-key.sh);
in {
  # bug: 2023-09-22: man-cache generation fails if programs.fish.enable = true;
  documentation.man.generateCaches = false;

  image.modules.iso = {
    isoImage = {
      makeEfiBootable = true;
      makeUsbBootable = true;
    };
  };

  environment.gnome.excludePackages = [pkgs.gnome-tour];
  environment.systemPackages = with pkgs; [
    bash
    fish
    gawk
    gnupg
    gpg-quick-generate-master-key
    keepassxc
    kitty
    monkeysphere
    neovim
    openssl
    paperkey
    qrencode
    yubico-piv-tool
    yubikey-manager
    yubioath-flutter
  ];

  hardware.nvidia.open = false;

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

    # 2022-06-19: the check fails, for some reason
    logrotate.checkConfig = false;

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

      videoDrivers = ["nvidia"];

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
