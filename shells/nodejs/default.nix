{
  pkgs ? import <nixpkgs> {},
  languages,
}: {
  nodejs = pkgs.mkShell {
    inherit (languages.nodejs) packages;
  };
  nodejs-16 = pkgs.mkShell {
    packages = with pkgs; [
      nodejs-16_x
      nodePackages.eslint
      nodePackages.typescript
      nodePackages.typescript-language-server
      yarn
    ];
  };
  nodejs-18 = pkgs.mkShell {
    packages = with pkgs; [
      nodejs-18_x
      nodePackages.eslint
      nodePackages.typescript
      nodePackages.typescript-language-server
      yarn
    ];
  };
}
