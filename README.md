# nix-user-repository

**My personal [NUR](https://github.com/nix-community/NUR) repository**

Repository based on the [nix-community/nur-packages-template](https://github.com/nix-community/nur-packages-template).

## Outputs

- NixOS Configurations
  - `offline-iso` - ISO/Installer, NixOS configuration with KeePass XC, GnuPG, etc.

- DevShells (Provide compiler/tool, LSP, linting, debugging, etc.; goes well with direnv):
  - go (`go`, `go_1_16`, `go_1_17`, `go_1_18`)
  - python (`python_3_6`, `python_3_7`, `python_3_8`, `python_3_9`, `python_3_10`)
  - rust (`rust_thumbv7em-none-eabihf` for STM32 development, `rust_wasm32-unknown-unknown` for working with Substrate)
  - terraform (`terraform`)

- Packages
  - `myPackages` env with packages I like on my desktop.
  - `devops-env-c` packages I like using for devops.

## Using NixOS Modules in a NixOS Configuration

A `flake.nix` making use of the NixOS modules might look like:

``` nix
{
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    rgoulter.url = "github:rgoulter/nix-user-repository";
  };

  outputs = { self, nixos-hardware, nixpkgs, rgoulter }: {
    nixosConfigurations = {
      YOUR-HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          rgoulter.nixosModules.bluetooth-headset
          rgoulter.nixosModules.virtualization
          # etc.
          self.nixosModules.system-hardware
        ];
      };
    };
    nixosModules = {
      system-hardware = import ./hardware-desktop.nix { inherit nixos-hardware; };
    };
  };
}
```

e.g. where `hardware-desktop.nix` may be something like:

``` nix
{ nixos-hardware }:

{
  imports =
    [
      nixos-hardware.nixosModules.common-cpu-intel-cpu-only
      nixos-hardware.nixosModules.common-gpu-nvidia
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd
      nixos-hardware.nixosModules.common-pc-hdd
    ];
}
```

On a computer with hostname `YOUR-HOSTNAME`, this can then be built with:

``` sh
$ nixos-rebuild build --flake .
```

or to set as the default boot entry:

``` sh
# nixos-rebuild boot --flake .
```

If using [specialisations](https://nixos.wiki/wiki/Specialisation) (e.g. the
`desktops` module), note that the command to switch configuration is, e.g. for `gnome`:

``` sh
/nix/var/nix/profiles/system/specialisation/gnome/bin/switch-to-configuration switch
```

## Running the 'Offline' NixOS Configuration in a VM

The intended use is to build the iso using

``` sh
nix build .#offline-iso
```

and then copying this ISO to thumbdrive. (e.g. to [Ventoy](https://www.ventoy.net/en/index.html)).

For faster iteration, it's also possible to use [nixos-shell](https://github.com/Mic92/nixos-shell/)

``` sh
nix run nixpkgs#nixos-shell -- --flake .#offline
```

or just directly run a qemu VM:

``` sh
nix run .#offline-vm
```

(take care to remove the `.qcow2` file when changing the `offline.nix` nixos module, though).
