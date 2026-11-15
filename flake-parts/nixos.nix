{
  inputs,
  self,
  ...
}: {
  perSystem = {
    lib,
    system,
    ...
  }: {
    checks = lib.optionalAttrs (system == "x86_64-linux") {
      offline-gpg = import ../tests/offline-gpg.nix {
        inherit lib;
        pkgs = import ../lib/unfree-pkgs.nix {
          nixpkgs = inputs.nixpkgs;
          inherit system;
        };
        offlineModule = self.nixosModules.offline;
      };
    };
  };

  flake = {
    nixosModules = import ../modules;

    nixosConfigurations.offline = inputs.nixpkgs.lib.nixosSystem {
      system = null;
      modules = [
        {
          nixpkgs.pkgs = import ../lib/unfree-pkgs.nix {
            nixpkgs = inputs.nixpkgs;
            system = "x86_64-linux";
          };
        }
        self.nixosModules.offline
        {
          # Placeholders so that toplevel evaluates for `nix flake check`.
          # The configuration is only booted as the ISO or as a VM.
          fileSystems."/" = {
            device = "none";
            fsType = "tmpfs";
          };
          boot.loader.grub.enable = false;
        }
      ];
    };

    packages.x86_64-linux.offline-iso =
      self.nixosConfigurations.offline.config.system.build.images.iso;
  };
}
