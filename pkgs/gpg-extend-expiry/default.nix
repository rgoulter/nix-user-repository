{
  writeShellApplication,
  coreutils,
  gawk,
  gnupg,
}:
writeShellApplication {
  name = "gpg-extend-expiry";
  runtimeInputs = [coreutils gawk gnupg];
  text = builtins.readFile ../../scripts/gpg-extend-expiry.sh;
}
