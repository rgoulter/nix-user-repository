{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules = import ../modules;

    packages.x86_64-linux.offline-iso = inputs.nixos-generators.nixosGenerate {
      pkgs = import ../lib/unfree-pkgs.nix {
        nixpkgs = inputs.nixpkgs;
        system = "x86_64-linux";
      };
      format = "iso";
      modules = [
        self.nixosModules.offline
      ];
    };
  };
}
