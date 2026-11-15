#!/usr/bin/env bash

usage() {
  cat <<'USAGE'
Usage: gpg-extend-expiry [-o FILE] FINGERPRINT [EXPIRY]

Set the expiry of the primary key and all subkeys of the secret key
FINGERPRINT, then export the armoured public key.

EXPIRY is any form gpg accepts, such as 1y, 90d or 2030-01-01.
It defaults to 1y.

Options:
  -o, --output FILE  write the public key to FILE
                     (default: ./FINGERPRINT.pub.asc)
  -h, --help         print this help

Environment:
  GPG_OPTS  extra options for every gpg invocation, split on whitespace,
            e.g. "--batch --pinentry-mode loopback --passphrase ''"
USAGE
}

output=""
args=()
while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  -o | --output)
    if [ $# -lt 2 ]; then
      echo "gpg-extend-expiry: $1 needs an argument" >&2
      exit 2
    fi
    output="$2"
    shift 2
    ;;
  -*)
    echo "gpg-extend-expiry: unknown option: $1" >&2
    usage >&2
    exit 2
    ;;
  *)
    args+=("$1")
    shift
    ;;
  esac
done

if [ "${#args[@]}" -lt 1 ] || [ "${#args[@]}" -gt 2 ]; then
  usage >&2
  exit 2
fi

fingerprint="${args[0]}"
expiry="${args[1]:-1y}"
output="${output:-./${fingerprint}.pub.asc}"

# Split GPG_OPTS on whitespace.
# A lone '' stands for an empty argument, as in --passphrase ''.
gpg_opts=()
if [ -n "${GPG_OPTS:-}" ]; then
  read -r -a words <<<"${GPG_OPTS}"
  for word in "${words[@]}"; do
    if [ "${word}" = "''" ]; then word=""; fi
    gpg_opts+=("${word}")
  done
fi

gpg_run() {
  gpg "${gpg_opts[@]}" "$@"
}

if ! gpg_run --list-secret-keys --with-colons "${fingerprint}" >/dev/null 2>&1; then
  echo "gpg-extend-expiry: no secret key for ${fingerprint} in the keyring" >&2
  exit 1
fi

gpg_run --quick-set-expire "${fingerprint}" "${expiry}"
gpg_run --quick-set-expire "${fingerprint}" "${expiry}" '*'

echo "New expiry dates:"
gpg_run --list-keys --with-colons "${fingerprint}" |
  awk -F ':' '
    /^(pub|sub):/ {
      if ($7 == "") { date = "never" }
      else { date = strftime("%Y-%m-%d", $7) }
      print ($1 == "pub" ? "primary" : "subkey ") " " $5 " expires " date
    }'

gpg_run --armor --output "${output}" --yes --export "${fingerprint}"
echo "Public key written to ${output}"
