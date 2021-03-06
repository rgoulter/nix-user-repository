{
  description = "My personal NUR repository";
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-2105.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-with-kicad5 = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "89f196fe781c53cb50fef61d3063fa5e8d61b6e5";
    };
  };
  outputs = { self, nixpkgs, nixos-2105, nixpkgs-with-kicad5, fenix, nixos-generators }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      apps = forAllSystems (system: {
        kicad5 = self.apps.${system}.kicad-5_1_12;
        kicad-5_1_12 = {
          type = "app";
          program = "${self.packages.${system}.kicad-5_1_12}/bin/kicad";
        };
      });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nixos-2105-pkgs = nixos-2105.legacyPackages.${system};
          fenix-pkgs = fenix.packages.${system};
        in
        import ./shells/go { inherit pkgs; } //
        import ./shells/python { inherit pkgs nixos-2105-pkgs; } //
        import ./shells/rust { inherit pkgs fenix-pkgs; } //
        import ./shells/terraform { inherit pkgs; });

      packages = forAllSystems (system: import ./default.nix {
        inherit nixos-generators;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-with-kicad5 = import nixpkgs-with-kicad5 {
          inherit system;
          config.allowUnfree = true;
        };
      });
    };
}
