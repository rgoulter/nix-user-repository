# GnuPG tasks for the offline image.
# Run with `offline-gpg RECIPE`; files are read from and written to the current directory.

# List the recipes
default:
    @just --justfile {{justfile()}} --list

# List secret keys, with fingerprints and expiry dates
list-keys:
    gpg --list-secret-keys --keyid-format long --with-fingerprint

# Import a secret key from PATH, e.g. a file on a mounted USB drive
import PATH:
    gpg --import "{{PATH}}"

# Generate a new master key and subkeys for "Name <email>"
generate NAME_AND_EMAIL="":
    gpg-quick-generate-master-key {{quote(NAME_AND_EMAIL)}}

# Set the expiry of the primary key and subkeys, and export the public key
extend-expiry FPR EXPIRY="1y":
    gpg-extend-expiry "{{FPR}}" "{{EXPIRY}}"

# Write the armoured public key to FPR.pub.asc
export-public FPR:
    gpg --armor --output "{{FPR}}.pub.asc" --export "{{FPR}}"

# Write a paperkey text backup to FPR.paperkey.txt; any PRINT value also prints it
backup-paperkey FPR PRINT="":
    gpg --export-secret-keys "{{FPR}}" | paperkey --output "{{FPR}}.paperkey.txt"
    if [ -n "{{PRINT}}" ]; then lp "{{FPR}}.paperkey.txt"; fi

# Show the status of the connected OpenPGP card
card-status:
    gpg --card-status
