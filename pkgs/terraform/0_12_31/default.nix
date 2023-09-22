{mkTerraform}:
mkTerraform {
  version = "0.12.31";
  hash = "sha256-z50WYdLz/bOhcMT7hkgaz35y2nVho50ckK/M1TpK5g4=";
  patches = [../provider-path.patch];
}
