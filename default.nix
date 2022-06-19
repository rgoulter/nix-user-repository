{ pkgs ? import <nixpkgs> { }
, pkgs-with-kicad5 ? import
    (builtins.fetchGit {
      name = "nixpkgs-with-kicad5";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "89f196fe781c53cb50fef61d3063fa5e8d61b6e5";
    })
    { }
, nixos-generators
}:

let
  makeEmacsChemacsProfile =
    pkgs.callPackage ./lib/make-emacs-chemacs-profile-application.nix {};
in
{
  python-openstackclient = pkgs.callPackage ./pkgs/python-openstackclient { };
  istioctl-1_7_8 = pkgs.callPackage ./pkgs/istioctl/1_7_8 { };
  istioctl-1_8_5 = pkgs.callPackage ./pkgs/istioctl/1_8_5 { };
  istioctl-1_9_7 = pkgs.callPackage ./pkgs/istioctl/1_9_7 { };
  istioctl-1_10_3 = pkgs.callPackage ./pkgs/istioctl/1_10_3 { };
  istioctl-1_11_0 = pkgs.callPackage ./pkgs/istioctl/1_11_0 { };
  terraform_0_12_9 = pkgs.callPackage ./pkgs/terraform/0_12_9 { };
  terraform_0_12_31 = pkgs.callPackage ./pkgs/terraform/0_12_31 { };
  devops-env-c = import ./pkgs/devops-env-c { inherit pkgs; };
  myPackages = import ./pkgs/myPackages { inherit pkgs makeEmacsChemacsProfile; };
  kicad-5_1_12 = pkgs-with-kicad5.kicad;

  offline-iso = nixos-generators.nixosGenerate {
    inherit pkgs;
    modules = [
      ./modules/installer/offline.nix
    ];
    format = "iso";
  };
}
