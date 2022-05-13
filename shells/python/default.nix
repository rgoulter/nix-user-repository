{ pkgs ? import <nixpkgs> {}
, nixos-2105-pkgs
}:
{
  python_3_6 =
  let
    pkgs = nixos-2105-pkgs;
  in
  pkgs.mkShell {
    packages = with pkgs; [
      libffi
      python36
      pyright
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
}
