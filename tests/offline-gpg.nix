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

    def as_nixos(cmd):
        return machine.succeed(
            f"su nixos -s ${pkgs.runtimeShell} -c {shlex.quote(cmd)}"
        ).strip()

    def expiries(fpr):
        out = as_nixos(f"gpg --list-keys --with-colons {fpr}")
        pub = [l.split(":")[6] for l in out.splitlines() if l.startswith("pub:")]
        sub = [l.split(":")[6] for l in out.splitlines() if l.startswith("sub:")]
        assert len(pub) == 1 and len(sub) == 1, out
        return int(pub[0]), int(sub[0])

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
        routes = machine.succeed("ip route show default").strip()
        assert routes == "", f"default route present: {routes}"
        addrs = machine.succeed("ip -o addr show scope global").strip()
        assert addrs == "", f"global addresses present: {addrs}"
        machine.fail("systemctl is-active NetworkManager.service")
        machine.fail("systemctl is-active bluetooth.service")
        machine.fail("lsmod | grep -E '^(bluetooth|cfg80211) '")

    with subtest("printing is available"):
        machine.succeed("systemctl is-enabled cups.socket || systemctl is-enabled cups.service")

    with subtest("extend key expiry"):
        as_nixos("gpg --batch --passphrase ''' --quick-generate-key 'Test <test@example.org>' ed25519 sign 1d")
        fpr = as_nixos("gpg --list-keys --with-colons | awk -F: '/^fpr/ {print $10; exit}'")
        as_nixos(f"gpg --batch --passphrase ''' --quick-add-key {fpr} cv25519 encr 1d")
        before = expiries(fpr)

        as_nixos(
            "cd \"$(mktemp -d)\" && "
            "GPG_OPTS=\"--batch --pinentry-mode loopback --passphrase '''\" "
            f"gpg-extend-expiry {fpr} 90d && "
            f"grep -q 'BEGIN PGP PUBLIC KEY BLOCK' {fpr}.pub.asc"
        )
        after = expiries(fpr)
        assert after[0] > before[0], f"primary expiry did not move: {before} -> {after}"
        assert after[1] > before[1], f"subkey expiry did not move: {before} -> {after}"

    with subtest("documentation"):
        assert "extend-expiry" in machine.succeed("offline-gpg --list")
        machine.succeed("man -w offline-gpg")
  '';
}
