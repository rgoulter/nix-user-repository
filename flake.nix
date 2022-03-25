{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-with-kicad5 = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "89f196fe781c53cb50fef61d3063fa5e8d61b6e5";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-with-kicad5 }:
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
        in
        {
          go = pkgs.mkShell {
            packages = with pkgs; [
              go
              gopls
            ];
          };
          go_1_16 = pkgs.mkShell {
            packages = with pkgs; [
              go_1_16
              gopls
            ];
          };
          go_1_17 = pkgs.mkShell {
            packages = with pkgs; [
              go_1_17
              gopls
            ];
          };
          go_1_18 = pkgs.mkShell {
            packages = with pkgs; [
              go_1_18
              gopls
            ];
          };

          python_3_7 = pkgs.mkShell {
            packages = with pkgs; [
              libffi
              python37
              pyright
            ];
          };
          python_3_8 = pkgs.mkShell {
            packages = with pkgs; [
              libffi
              python38
              pyright
            ];
          };
          python_3_9 = pkgs.mkShell {
            packages = with pkgs; [
              libffi
              python39
              pyright
            ];
          };
          python_3_10 = pkgs.mkShell {
            packages = with pkgs; [
              libffi
              python310
              pyright
            ];
          };

          terraform = pkgs.mkShell {
            packages = with pkgs; [
              terraform
              terraform-ls
              tflint
            ];
          };
        });
      packages = forAllSystems (system: import ./default.nix {
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
