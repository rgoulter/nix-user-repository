{ pkgs ? import <nixpkgs> {} }:
{
  terraform = pkgs.mkShell {
    packages = with pkgs; [
      terraform
      terraform-ls
      tflint
    ];
  };
}