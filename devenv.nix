{
  pkgs,
  config,
  ...
}: {
  packages = with pkgs; [
    treefmt
  ];

  languages = {
    nix.enable = true;
    shell.enable = true;
  };
}
