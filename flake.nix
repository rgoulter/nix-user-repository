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
    nixos-shell = {
      url = "github:Mic92/nixos-shell";
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
  outputs = {
    self,
    nixpkgs,
    nixos-2105,
    nixpkgs-with-kicad5,
    fenix,
    nixos-generators,
    nixos-shell,
  }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    apps.x86_64-linux.kicad5 = {
      type = "app";
      program = "${self.packages.x86_64-linux.kicad-5_1_12}/bin/kicad";
    };

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nixos-2105-pkgs = nixos-2105.legacyPackages.${system};
      fenix-pkgs = fenix.packages.${system};
    in
      import ./shells {inherit pkgs fenix-pkgs;}
      // import ./shells/python/old.nix {inherit nixos-2105-pkgs;}
      // {
        default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            shellcheck
            shfmt
            treefmt
          ];
        };
      });

    nixosConfigurations = {
      "offline-iso" = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/installer/offline.nix
          nixos-shell.nixosModules.nixos-shell
        ];
      };
    };

    nixosModules = import ./modules;

    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsUnfree = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
        import ./pkgs {inherit pkgs;}
        // {
          devops-env-c = import ./pkgs/devops-env-c {inherit pkgs;};
          myPackages = import ./pkgs/myPackages {
            makeEmacsChemacsProfile =
              pkgs.callPackage ./lib/make-emacs-chemacs-profile-application.nix {};
            pkgs = pkgsUnfree;
          };
        }
        // (
          if system == "x86_64-linux"
          then {
            kicad-5_1_12 = let
              pkgs-with-kicad5 = import nixpkgs-with-kicad5 {
                inherit system;
                # config.allowUnfree = true;
              };
            in
              pkgs-with-kicad5.kicad;
            offline-iso = nixos-generators.nixosGenerate {
              pkgs = nixpkgs.legacyPackages.${system};
              format = "iso";
              modules = [
                ./modules/installer/offline.nix
              ];
            };
          }
          else {}
        )
    );
  };
}
