# NixOS VM test for the offline GPG configuration.
# It imports the real offline module and only switches the graphical
# session off, so that the VM boots headless.
# The assertions check that the machine is air-gapped and that the
# key-expiry workflow works for the nixos user.
{
  lib,
  pkgs,
  offlineModule,
}:
pkgs.testers.runNixOSTest {
  name = "offline-gpg";

  nodes.machine = {
    imports = [offlineModule];

    # A small VM, so that the test fits alongside a desktop in use.
    # No test VLANs, so the driver does not give the VM an address.
    virtualisation = {
      cores = 1;
      memorySize = 1536;
      vlans = [];
    };

    services = {
      xserver = {
        enable = lib.mkForce false;
        videoDrivers = lib.mkForce [];
      };
      desktopManager.gnome.enable = lib.mkForce false;
      displayManager = {
        autoLogin.enable = lib.mkForce false;
        gdm.enable = lib.mkForce false;
      };
    };
  };

  testScript = ''
    import shlex
    from dataclasses import dataclass

    # The NixOS test driver provides machine and subtest.

    def as_nixos(cmd):
        return machine.succeed(
            f"su nixos -s ${pkgs.runtimeShell} -c {shlex.quote(cmd)}"
        ).strip()

    @dataclass(frozen=True)
    class KeyExpiry:
        fingerprint: str
        expires_at: int

    def parse_key_expiries(listing):
        """Parse `gpg --list-keys --with-colons` into role -> KeyExpiry.

        Field 7 (index 6) is the expiry as a Unix timestamp.
        The `fpr` record that follows a pub or sub line is that key's fingerprint.
        This test sets up exactly one primary key and one subkey.
        """
        by_role = {"primary": [], "subkey": []}
        pending = None
        for line in listing.splitlines():
            fields = line.split(":")
            kind = fields[0]
            if kind == "pub":
                pending = ("primary", int(fields[6]))
            elif kind == "sub":
                pending = ("subkey", int(fields[6]))
            elif kind == "fpr" and pending is not None:
                role, expires_at = pending
                by_role[role].append(
                    KeyExpiry(fingerprint=fields[9], expires_at=expires_at)
                )
                pending = None

        primary = by_role["primary"]
        subkey = by_role["subkey"]
        assert len(primary) == 1 and len(subkey) == 1, (
            "expected exactly one primary key and one subkey in the GPG listing, "
            "found %d primary and %d subkey. Raw listing:\n%s"
            % (len(primary), len(subkey), listing)
        )
        return {"primary": primary[0], "subkey": subkey[0]}

    # connect() gives up after 300 seconds, which software emulation
    # without KVM can exceed, so the wait is repeated.
    for attempt in range(4):
        try:
            machine.connect()
            break
        except RuntimeError:
            if attempt == 3:
                raise
    machine.wait_for_unit("multi-user.target", timeout=900)

    with subtest("machine is offline"):
        # Assemble: The VM has booted the offline module, with no test VLAN.
        # Act: Read the default route, global addresses, and service or module state.
        routes = machine.succeed("ip route show default").strip()
        addrs = machine.succeed("ip -o addr show scope global").strip()
        # Assert: There is no default route or global address,
        #  and NetworkManager, Bluetooth, and the wireless and Bluetooth modules are off.
        assert routes == "", f"default route present: {routes}"
        assert addrs == "", f"global addresses present: {addrs}"
        machine.fail("systemctl is-active NetworkManager.service")
        machine.fail("systemctl is-active bluetooth.service")
        machine.fail("lsmod | grep -E '^(bluetooth|cfg80211) '")

    with subtest("printing is available"):
        # Assemble: The offline module enables CUPS.
        # Act: Query whether cups.socket or cups.service is enabled.
        # Assert: At least one of those units is enabled.
        machine.succeed("systemctl is-enabled cups.socket || systemctl is-enabled cups.service")

    with subtest("extend key expiry"):
        # Assemble: Create one primary signing key and one encryption subkey for the nixos user,
        #  then record their expiry timestamps.
        as_nixos("gpg --batch --passphrase ''' --quick-generate-key 'Test <test@example.org>' ed25519 sign 1d")
        fpr = as_nixos("gpg --list-keys --with-colons | awk -F: '/^fpr/ {print $10; exit}'")
        as_nixos(f"gpg --batch --passphrase ''' --quick-add-key {fpr} cv25519 encr 1d")
        listing_before = as_nixos(f"gpg --list-keys --with-colons {fpr}")
        expiries_before = parse_key_expiries(listing_before)
        primary_expiry_before = expiries_before["primary"].expires_at
        subkey_expiry_before = expiries_before["subkey"].expires_at

        # Act: Extend both expiries by 90 days and export the public key.
        as_nixos(
            "cd \"$(mktemp -d)\" && "
            "GPG_OPTS=\"--batch --pinentry-mode loopback --passphrase '''\" "
            f"gpg-extend-expiry {fpr} 90d && "
            f"grep -q 'BEGIN PGP PUBLIC KEY BLOCK' {fpr}.pub.asc"
        )

        # Assert: The export is an armoured public key (checked above),
        #  and both expiry timestamps moved later than the values recorded
        #  before the extension.
        listing_after = as_nixos(f"gpg --list-keys --with-colons {fpr}")
        expiries_after = parse_key_expiries(listing_after)
        primary_expiry_after = expiries_after["primary"].expires_at
        subkey_expiry_after = expiries_after["subkey"].expires_at
        assert primary_expiry_after > primary_expiry_before, (
            "primary expiry did not move later: "
            "fingerprint=%s, primary_expiry_before=%s, primary_expiry_after=%s"
            % (
                expiries_after["primary"].fingerprint,
                primary_expiry_before,
                primary_expiry_after,
            )
        )
        assert subkey_expiry_after > subkey_expiry_before, (
            "subkey expiry did not move later: "
            "fingerprint=%s, subkey_expiry_before=%s, subkey_expiry_after=%s"
            % (
                expiries_after["subkey"].fingerprint,
                subkey_expiry_before,
                subkey_expiry_after,
            )
        )

    with subtest("documentation"):
        # Assemble: The command and its man page are installed.
        # Act: Read the recipe list and resolve the man page path.
        recipes = machine.succeed("offline-gpg --list")
        # Assert: The list mentions extend-expiry, and the man page is installed.
        assert "extend-expiry" in recipes
        machine.succeed("man -w offline-gpg")
  '';
}
