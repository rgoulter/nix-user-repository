{pkgs}: {
  python-openstackclient = pkgs.callPackage ./python-openstackclient {};
  istioctl-1_11_0 = pkgs.callPackage ./istioctl/1_11_0 {};
}
