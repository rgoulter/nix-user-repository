{mkTerraform}:
mkTerraform {
  version = "0.12.9";
  sha256 = "sha256-aubq32L3ED460L6zsxgx69LndTrKgpol8GC8jIAlWpI=";
  patches = [../provider-path.patch];
}
