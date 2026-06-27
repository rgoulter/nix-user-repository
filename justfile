# Flake commands for day-to-day development.

devenv-root := "file+file://" + justfile_directory()

# Show available recipes
default:
    @just --list

# Build myPackages (same as plain `nix build`)
alias b := build

build:
    nix build --override-input devenv-root "{{devenv-root}}"

# Run all flake checks (formatting, etc.)
alias c := check

check:
    nix flake check --override-input devenv-root "{{devenv-root}}"

# Format the repository
alias f := fmt

fmt:
    nix fmt
