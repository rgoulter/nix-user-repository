{
  description = "My personal NUR repository";
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-shell = {
      url = "github:Mic92/nixos-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    naersk,
    nixpkgs,
    fenix,
    nixos-generators,
    nixos-shell,
  }: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      fenix-pkgs = fenix.packages.${system};
    in
      import ./shells {inherit pkgs fenix-pkgs;}
      // {
        default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            shellcheck
            shfmt
            treefmt
          ];
        };
        tslab-deps = let
          # required to install tslab on macOS
          zeromq-deps = [
            pkgs.cmake
            pkgs.pkgconfig
            pkgs.zeromq
            pkgs.libsodium # macos
          ];
        in
          pkgs.mkShell {
            packages = zeromq-deps;
          };
      });

    nixosConfigurations = {
      "offline-iso" = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {nixpkgs.config = {allowUnfree = true;};}
          self.nixosModules.offline
        ];
      };
    };

    lib = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      fenix-pkgs = fenix.packages.${system};
    in
      import ./lib {
        inherit pkgs fenix-pkgs;
      });

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
        // (import ./pkgs/blockchain {
          inherit pkgs naersk;
          languages = import ./lib/languages {
            inherit pkgs;
            fenix-pkgs = fenix.packages.${system};
          };
        })
        // {
          devops-env-c = import ./pkgs/devops-env-c {inherit pkgs;};
          myPackages = import ./pkgs/myPackages {
            makeEmacsChemacsProfile =
              pkgs.callPackage ./lib/make-emacs-chemacs-profile-application.nix {};
            pkgs = pkgsUnfree;
          };
          myPackages-lite = import ./pkgs/myPackages/lite.nix {
            makeEmacsChemacsProfile =
              pkgs.callPackage ./lib/make-emacs-chemacs-profile-application.nix {};
            pkgs = pkgsUnfree;
          };
        }
        // (
          if system == "x86_64-linux"
          then {
            offline-iso-vm = self.nixosConfigurations."offline-iso".config.system.build.vm;
            offline-iso = nixos-generators.nixosGenerate {
              pkgs = import nixpkgs {
                inherit system;
                config = {allowUnfree = true;};
              };
              format = "iso";
              modules = [
                ./modules/installer/offline.nix
                self.nixosModules.offline
              ];
            };
          }
          else {}
        )
    );
  };
}
