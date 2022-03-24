{ pkgs ? import <nixpkgs> { }
, pkgs-with-kicad5 ? import
    (builtins.fetchGit {
      name = "nixpkgs-with-kicad5";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "89f196fe781c53cb50fef61d3063fa5e8d61b6e5";
    })
    { }
}:

{
  python-openstackclient = pkgs.callPackage ./pkgs/python-openstackclient { };
  istioctl-1_7_8 = pkgs.callPackage ./pkgs/istioctl/1_7_8 { };
  istioctl-1_8_6 = pkgs.callPackage ./pkgs/istioctl/1_8_6 { };
  terraform_0_12_9 = pkgs.callPackage ./pkgs/terraform/0_12_9 { };
  devops-env-c = import ./pkgs/devops-env-c { pkgs = pkgs; };
  myPackages = import ./pkgs/myPackages { inherit pkgs; };
  kicad-5_1_12 = pkgs-with-kicad5.kicad;
}
