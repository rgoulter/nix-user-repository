{pkgs}: {
  python-openstackclient = pkgs.callPackage ./python-openstackclient {};
  istioctl-1_11_0 = pkgs.callPackage ./istioctl/1_11_0 {};
  terraform_0_12_9 = pkgs.callPackage ./terraform/0_12_9 {};
  terraform_0_12_31 = pkgs.callPackage ./terraform/0_12_31 {};
}
