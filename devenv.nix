{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    programs.treefmt = {
      package = lib.mkOption {
        defaultText = lib.literalMD "package for running `treefmt` in devshell";
      };
    };
  };

  config = {
    packages = with pkgs; [
      config.programs.treefmt.package
    ];

    languages = {
      nix.enable = true;
      shell.enable = true;
    };
  };
}
