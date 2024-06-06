{
  description = "My personal NUR repository";
  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    devenv-root,
    devenv,
    flake-parts,
    naersk,
    nixpkgs,
    fenix,
    nixos-generators,
    nixos-shell,
    systems,
    treefmt-nix,
    ...
  }: let
    flake = {
      nixosModules = import ./modules;

      packages.x86_64-linux.offline-iso = nixos-generators.nixosGenerate {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {allowUnfree = true;};
        };
        format = "iso";
        modules = [
          self.nixosModules.offline
        ];
      };
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit flake;

      systems = import systems;

      imports = [
        devenv.flakeModule
        treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devenv.shells.default = {pkgs, ...}: {
          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          # https://github.com/cachix/devenv/issues/528
          containers = pkgs.lib.mkForce {};

          imports = [./devenv.nix];
        };

        devShells = let
          fenix-pkgs = fenix.packages.${system};
        in
          import ./shells {inherit pkgs fenix-pkgs;}
          // {
            tslab-deps = let
              # required to install tslab on macOS
              zeromq-deps = [
                pkgs.cmake
                pkgs.pkg-config
                pkgs.zeromq
                pkgs.libsodium # macos
              ];
            in
              pkgs.mkShell {
                packages = zeromq-deps;
              };
          };

        packages = let
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
          };

        treefmt = import ./treefmt.nix;
      };
    };
}
