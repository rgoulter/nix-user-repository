{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  go = pkgs.mkShell {
    inherit (languages.go) packages;
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
}
