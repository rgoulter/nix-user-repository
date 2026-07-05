{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devenv.shells.default = {pkgs, ...}: {
      devenv.root = let
        devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
      in
        pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

      # https://github.com/cachix/devenv/issues/528
      containers = pkgs.lib.mkForce {};

      programs.treefmt.package = config.treefmt.build.wrapper;

      imports = [../devenv.nix];
    };
  };
}
