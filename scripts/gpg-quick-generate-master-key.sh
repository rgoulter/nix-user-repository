#!/usr/bin/env bash

set -ex

NAME_AND_EMAIL="$1"
if [ -z "$1" ]; then
  NAME_AND_EMAIL="Richard Goulter <richard.goulter@gmail.com>"
fi

EXPIRY=90d

gpg --quick-generate-key "${NAME_AND_EMAIL}" default sign "${EXPIRY}"

FINGERPRINT=$(
  gpg --list-secret-keys --with-colons "${NAME_AND_EMAIL}" |
    awk -F ':' '/fpr/ { print $10; exit; }'
)

gpg --quick-add-key "${FINGERPRINT}" default encr "${EXPIRY}"

gpg --quick-add-key "${FINGERPRINT}" default sign "${EXPIRY}"

gpg --quick-add-key "${FINGERPRINT}" default auth "${EXPIRY}"
