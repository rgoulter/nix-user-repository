{ pkgs }:

{
  python-openstackclient = pkgs.callPackage ./python-openstackclient { };
  istioctl-1_7_8 = pkgs.callPackage ./istioctl/1_7_8 { };
  istioctl-1_8_5 = pkgs.callPackage ./istioctl/1_8_5 { };
  istioctl-1_9_7 = pkgs.callPackage ./istioctl/1_9_7 { };
  istioctl-1_10_3 = pkgs.callPackage ./istioctl/1_10_3 { };
  istioctl-1_11_0 = pkgs.callPackage ./istioctl/1_11_0 { };
  terraform_0_12_9 = pkgs.callPackage ./terraform/0_12_9 { };
  terraform_0_12_31 = pkgs.callPackage ./terraform/0_12_31 { };
}
