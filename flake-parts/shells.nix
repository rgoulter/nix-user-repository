{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells = let
      fenix-pkgs = inputs.fenix.packages.${system};
    in
      import ../shells {inherit pkgs fenix-pkgs;}
      // {
        tslab-deps = let
          # required to install tslab on macOS
          zeromq-deps = [
            pkgs.cmake
            pkgs.pkg-config
            pkgs.zeromq
            pkgs.libsodium
          ];
        in
          pkgs.mkShell {
            packages = zeromq-deps;
          };
      };
  };
}
