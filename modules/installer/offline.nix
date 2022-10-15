# offline.nix - NixOS configuration for an "offline"
#  NixOS ISO, for e.g. generating a KeePassXC diceware
#  passphrase, or manipulating PGP / GnuPG keys.
{
  config,
  pkgs,
  ...
}: let
  gpg-quick-generate-master-key =
    pkgs.writeScriptBin
    "gpg-quick-generate-master-key"
    (pkgs.lib.readFile ../../scripts/gpg-quick-generate-master-key.sh);
in {
  environment.systemPackages = with pkgs; [
    bash
    firefox
    fish
    gawk
    gnupg
    gpg-quick-generate-master-key
    keepassxc
    kitty
    monkeysphere
    neovim
    openssh
    openssl
    paperkey
    pinentry-gtk2
    pinentry-gnome
    qrencode
    yubico-piv-tool
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization-gui
  ];

  services = {
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

    # Enable the X11 windowing system.
    xserver = {
      # Enable the GNOME 3 Desktop Environment.
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin = {
          enable = true;
          user = "nixos";
        };
      };

      enable = true;

      videoDrivers = ["nvidia"];

      layout = "us";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05";

  time.timeZone = "Asia/Jakarta";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    password = "nixos";
    uid = 1000;
  };
}
