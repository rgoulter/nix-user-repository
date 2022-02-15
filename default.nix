{ pkgs ? import <nixpkgs> { } }:

{
  python-openstackclient = pkgs.callPackage ./pkgs/python-openstackclient { };
  istioctl-1_7_8 = pkgs.callPackage ./pkgs/istioctl/1_7_8 { };
  istioctl-1_8_6 = pkgs.callPackage ./pkgs/istioctl/1_8_6 { };
  terraform_0_12_9 = pkgs.callPackage ./pkgs/terraform/0_12_9 { };
  myPackages = import ./pkgs/myPackages { pkgs = pkgs; };
}
