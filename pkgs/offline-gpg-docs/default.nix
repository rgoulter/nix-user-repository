{runCommand}:
runCommand "offline-gpg-docs" {} ''
  install -Dm644 ${../../docs/offline-gpg.7} $out/share/man/man7/offline-gpg.7
''
