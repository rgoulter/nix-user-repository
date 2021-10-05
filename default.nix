{ pkgs ? import <nixpkgs> { } }:

{
  python-openstackclient = pkgs.callPackage ./pkgs/python-openstackclient { };
  istioctl-1_7_8 = pkgs.callPackage ./pkgs/istioctl/1_7_8 { };
  istioctl-1_8_6 = pkgs.callPackage ./pkgs/istioctl/1_8_6 { };
}
